//
//  APITests.swift
//  SwiftStack
//
//  Created by NobodyNada on 12/3/16.
//
//

import XCTest
@testable import SwiftStack

///An APIClient that allows inspecting and overriding requests and responses.
class TestableClient: APIClient {
	var requestHandler: ((URLSessionTask) -> (Data?, HTTPURLResponse?, Error?))?
	
	func onRequest(_ handler: ((URLSessionTask) -> (Data?, HTTPURLResponse?, Error?))?) {
		requestHandler = handler
	}
	
	override func performTask(_ task: URLSessionTask, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		if let handler = requestHandler {
			let result = handler(task)
			completion(result.0, result.1, result.2)
		} else {
			super.performTask(task, completion: completion)
		}
	}
}

class APITests: XCTestCase {
	//MARK: - Helpers
	var client: TestableClient!
	
	override func setUp() {
		client = TestableClient()
	}
	
	static var allTests : [(String, (APITests) -> () throws -> Void)] {
		return [
			("testQuota", testQuota)
		]
	}
	
	
	
	func blankResponse(_ task: URLSessionTask) -> HTTPURLResponse {
		return HTTPURLResponse(
			url: task.currentRequest!.url!,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)!
	}
	
	func parameters(from url: URL) -> [String:String] {
		guard let query = url.query else {
			return [:]
		}
		
		var result = [String:String]()
		
		for component in query.components(separatedBy: "&") {
			let components = component.components(separatedBy: "=")
			guard components.count == 2 else {
				continue
			}
			
			result[components.first!] = components.last!
		}
		
		return result
	}
	
	
	
	
	
	//MARK: - Tests
	func testRequest() throws {
		let expectedHost = "api.stackexchange.com"
		let expectedPath = "/2.2/info"
		let expectedParameters = ["site":"stackoverflow", "filter":"default"]
		
		client.defaultSite = "stackoverflow"
		client.defaultFilter = "default"
		client.onRequest {task in
			let url = task.currentRequest!.url!
			
			let actualHost = url.host
			let actualPath = url.path
			let actualParameters = self.parameters(from: url)
			XCTAssertEqual(expectedHost, actualHost)
			XCTAssertEqual(expectedPath, actualPath)
			XCTAssertEqual(expectedParameters, actualParameters)
			
			return ("{}".data(using: .utf8), self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest("info")
	}
	
	
	
	func testCustomParameters() throws {
		let expectedParameters = ["site":"stackoverflow", "filter":"default", "page":"1"]
		
		client.defaultSite = "stackoverflow"
		client.defaultFilter = "default"
		
		client.onRequest {task in
			let url = task.currentRequest!.url!
			
			let actualParameters = self.parameters(from: url)
			XCTAssertEqual(expectedParameters, actualParameters)
			
			return ("{}".data(using: .utf8), self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest("info", ["page":"1"])
	}
	
	
	
	func testOverridenParameters() throws {
		let parameters = ["site":"meta", "filter":"withbody"]
		
		client.defaultSite = "stackoverflow"
		client.defaultFilter = "default"
		
		client.onRequest {task in
			let url = task.currentRequest!.url!
			
			let actualParameters = self.parameters(from: url)
			XCTAssertEqual(parameters, actualParameters)
			
			return ("{}".data(using: .utf8), self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest("info", parameters)
	}
	
	
	
	func testQuota() throws {
		let expectedQuota = 123
		let expectedMaxQuota = 456
		client.onRequest {task in
			let responseJSON =
			"{\"has_more\": false, \"items\": [], \"quota_remaining\": \(expectedQuota), \"quota_max\": \(expectedMaxQuota)}"
			
			return (responseJSON.data(using: .utf8)!, self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest("info")
		
		XCTAssert(client.quota == expectedQuota,
		          "quota \"\(client.quota)\" is incorrect (should be \"\(expectedQuota)\")")
		
		XCTAssert(client.maxQuota == expectedMaxQuota,
		          "quotaMax \"\(client.maxQuota)\" is incorrect (should be \"\(expectedMaxQuota)\")")
	}
}
