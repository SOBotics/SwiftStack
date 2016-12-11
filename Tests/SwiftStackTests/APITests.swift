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
	var waitHandler: ((Date) -> Void)?
	
	func onRequest(_ handler: ((URLSessionTask) -> (Data?, HTTPURLResponse?, Error?))?) {
		requestHandler = handler
	}
	
	func onWait(_ handler: ((Date) -> Void)?) {
		waitHandler = handler
	}
	
	override func performTask(_ task: URLSessionTask, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		if let handler = requestHandler {
			let result = handler(task)
			completion(result.0, result.1, result.2)
		} else {
			super.performTask(task, completion: completion)
		}
	}
	
	override func wait(until date: Date) {
		if let handler = waitHandler {
			handler(date)
		} else {
			super.wait(until: date)
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
	
	
	let backoffTime: TimeInterval = 1
	
	
	func prepareBackoff() throws {
		client.onRequest {task in
			let responseJSON = "{\"backoff\": \(Int(self.backoffTime))}"
			
			return (responseJSON.data(using: .utf8), self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest("info")
		
		client.onRequest {task in
			return ("{}".data(using: .utf8), self.blankResponse(task), nil)
		}
	}
	
	func testBackoff() throws {
		try prepareBackoff()
		
		let expiration = client.backoffs["info"]?.timeIntervalSinceReferenceDate
		
		XCTAssertNotNil(expiration, "backoff missing")
		XCTAssertEqualWithAccuracy(
			expiration ?? -1,
			backoffTime + Date().timeIntervalSinceReferenceDate,
			accuracy: 0.1, "backoff incorrect"
		)
	}
	
	func testThrowingBackoff() throws {
		try prepareBackoff()
		
		XCTAssertThrowsError(try client.performAPIRequest("info", backoffBehavior: .throwError))
	}
	
	func testWaitingBackoff() throws {
		try prepareBackoff()
		
		let expiration = client.backoffs["info"]?.timeIntervalSinceReferenceDate ?? -1
		
		client.onWait {date in
			XCTAssertEqualWithAccuracy(
				date.timeIntervalSinceReferenceDate,
				expiration,
				accuracy: 0.1, "waiting time incorrect"
			)
			self.client.backoffs["info"] = Date()
		}
		
		//test waiting backoff
		let _ = try client.performAPIRequest("info", backoffBehavior: .wait)
		
		//make sure the backoff is cleaned up
		XCTAssertNil(client.backoffs["info"], "backoff was not cleaned up after waiting")
	}
	
	func testBackoffCleanup() throws {
		try prepareBackoff()
		
		client.backoffs["info"] = Date.distantPast
		let _ = try client.performAPIRequest("users/1")
		XCTAssertNil(client.backoffs["info"], "backoff was not cleaned up")
	}
    
    
    
    func testSitesRequest() {
        //not working yet. Just to show how to use the test method
        client.fetchSites() {
            response, error in
            print(error)
        }
    }
    
}
