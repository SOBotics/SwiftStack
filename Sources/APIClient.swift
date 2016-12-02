//
//  APIClient.swift
//  SwiftStack
//
//  Created by NobodyNada on 12/2/16.
//
//

import Foundation
import Dispatch

extension String {
	var urlEncodedString: String {
		var allowed = CharacterSet.urlQueryAllowed
		allowed.remove(charactersIn: "&+")
		return self.addingPercentEncoding(withAllowedCharacters: allowed)!
	}
	
	init(urlParameters: [String:String]) {
		var result = [String]()
		
		for (key, value) in urlParameters {
			result.append("\(key.urlEncodedString)=\(value.urlEncodedString)")
		}
		
		self.init(result.joined(separator: "&"))!
	}
}

open class APIClient: NSObject, URLSessionDataDelegate {
	open var session: URLSession!
	
	open let queue = DispatchQueue(label: "API queue", attributes: [.concurrent])
	
	public enum RequestError: Error {
		case invalidURL(url: String)
		case notUTF8
		case unknownError
	}
	
	private class HTTPTask {
		var task: URLSessionTask
		var completion: (Data?, HTTPURLResponse?, Error?) -> Void
		
		var data: Data?
		var response: HTTPURLResponse?
		var error: Error?
		
		init(task: URLSessionTask, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
			self.task = task
			self.completion = completion
		}
	}
	
	private var tasks = [URLSessionTask:HTTPTask]()
	
	private var responseSemaphore: DispatchSemaphore?
	
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		didReceive response: URLResponse,
		completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		
		guard let task = tasks[dataTask] else {
			print("\(dataTask) is not in client task list; cancelling")
			completionHandler(.cancel)
			return
		}
		
		var headers = [String:String]()
		for (k, v) in (response as? HTTPURLResponse)?.allHeaderFields ?? [:] {
			headers[String(describing: k)] = String(describing: v)
		}
		
		
		task.response = response as? HTTPURLResponse
		completionHandler(.allow)
	}
	
	public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		guard let task = tasks[dataTask] else {
			print("\(dataTask) is not in client task list; ignoring")
			return
		}
		
		if task.data != nil {
			task.data!.append(data)
		}
		else {
			task.data = data
		}
	}
	
	public func urlSession(_ session: URLSession, task sessionTask: URLSessionTask, didCompleteWithError error: Error?) {
		guard let task = tasks[sessionTask] else {
			print("\(sessionTask) is not in client task list; ignoring")
			return
		}
		task.error = error
		
		task.completion(task.data, task.response, task.error)
		
		tasks[sessionTask] = nil
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		willPerformHTTPRedirection response: HTTPURLResponse,
		newRequest request: URLRequest,
		completionHandler: @escaping (URLRequest?) -> Void
		) {
		
		var headers = [String:String]()
		for (k, v) in response.allHeaderFields {
			headers[String(describing: k)] = String(describing: v)
		}
		
		completionHandler(request)
	}
	
	private func performTask(_ task: URLSessionTask, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		tasks[task] = HTTPTask(task: task, completion: completion)
		task.resume()
	}
	
	open func performRequest(_ request: URLRequest) throws -> (Data, HTTPURLResponse) {
		let req = request
		
		let sema = DispatchSemaphore(value: 0)
		var data: Data!
		var resp: URLResponse!
		var error: Error!
		
		
		
		//TODO: I don't think this needs to be on the client queue anymore
		queue.async {
			let task = self.session.dataTask(with: req)
			self.performTask(task) {inData, inResp, inError in
				(data, resp, error) = (inData, inResp, inError)
				sema.signal()
			}
			
		}
		
		sema.wait()
		
		guard let response = resp as? HTTPURLResponse, data != nil else {
			throw error
		}
		
		return (data, response)
	}
	
	open func get(_ url: String) throws -> (Data, HTTPURLResponse) {
		guard let nsUrl = URL(string: url) else {
			throw RequestError.invalidURL(url: url)
		}
		var request = URLRequest(url: nsUrl)
		request.setValue(String(request.httpBody?.count ?? 0), forHTTPHeaderField: "Content-Length")
		return try performRequest(request)
	}
	
	open func post(_ url: String, _ data: [String:String]) throws -> (Data, HTTPURLResponse) {
		guard let nsUrl = URL(string: url) else {
			throw RequestError.invalidURL(url: url)
		}
		guard let data = String(urlParameters: data).data(using: String.Encoding.utf8) else {
			throw RequestError.notUTF8
		}
		var request = URLRequest(url: nsUrl)
		request.httpMethod = "POST"
		
		
		
		let sema = DispatchSemaphore(value: 0)
		
		var responseData: Data?
		var resp: HTTPURLResponse?
		var responseError: Error?
		
		queue.async {
			let task = self.session.uploadTask(with: request, from: data)
			self.performTask(task) {data, response, error in
				(responseData, resp, responseError) = (data, response, error)
				sema.signal()
			}
		}
		
		sema.wait()
		
		
		guard let response = resp else {
			throw responseError ?? RequestError.unknownError
		}
		
		if responseData == nil {
			responseData = Data()
		}
		
		return (responseData!, response)
	}
	
	open func performRequest(_ request: URLRequest) throws -> String {
		let (data, _) = try performRequest(request)
		guard let string = String(data: data, encoding: String.Encoding.utf8) else {
			throw RequestError.notUTF8
		}
		return string
	}
	
	open func get(_ url: String) throws -> String {
		let (data, _) = try get(url)
		guard let string = String(data: data, encoding: String.Encoding.utf8) else {
			throw RequestError.notUTF8
		}
		return string
	}
	
	open func post(_ url: String, _ fields: [String:String]) throws -> String {
		let (data, _) = try post(url, fields)
		guard let string = String(data: data, encoding: String.Encoding.utf8) else {
			throw RequestError.notUTF8
		}
		return string
	}
	
	open func parseJSON(_ json: String) throws -> Any {
		return try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments)
	}
	
	
	public init(proxyAddress: String? = nil, proxyPort: Int = 80) {
		super.init()
		
		let configuration =  URLSessionConfiguration.default
		
		if proxyAddress != nil {
			#if os(Linux)
				fatalError("proxies are not supported on Linux")
			#else
				configuration.connectionProxyDictionary = [
					"HTTPEnable" : 1,
					kCFNetworkProxiesHTTPProxy as AnyHashable : proxyAddress!,
					kCFNetworkProxiesHTTPPort as AnyHashable : proxyPort,
					
					"HTTPSEnable" : 1,
					kCFNetworkProxiesHTTPSProxy as AnyHashable : proxyAddress!,
					kCFNetworkProxiesHTTPSPort as AnyHashable : proxyPort
				]
			#endif
		}
		
		configuration.httpCookieStorage = nil
		
		
		let delegateQueue = OperationQueue()
		delegateQueue.maxConcurrentOperationCount = 1
		
		session = URLSession(
			configuration: configuration,
			delegate: self, delegateQueue: delegateQueue
		)
	}
}
