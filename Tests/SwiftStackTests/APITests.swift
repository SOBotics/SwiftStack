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
    
    var expectation: XCTestExpectation?
	
	override func setUp() {
		client = TestableClient()
	}
	
	static var allTests : [(String, (APITests) -> () throws -> Void)] {
		return [
			("testRequest", testRequest),
			("testCustomParameters", testCustomParameters),
			("testOverridenParameters", testOverridenParameters),
			
			("testBackoff", testBackoff),
			("testThrowingBackoff", testThrowingBackoff),
			("testWaitingBackoff", testWaitingBackoff),
			("testComplexRequestBackoff", testComplexRequestBackoff),
			("testBackoffCleanup", testBackoffCleanup),
			
			("testFetchSitesSync", testFetchSitesSync),
			("testFetchSitesAsync", testFetchSitesAsync),
			
			("testFetchRevisionSync", testFetchRevisionsSync),
			("testFetchRevisionAsync", testFetchRevisionAsync),
			
			("testFetchSuggestedEditsSync", testFetchSuggestedEditsSync),
			("testFetchSuggestedEditsAsync", testFetchSuggestedEditsAsync),
			("testFetchAllSuggestedEditsSync", testFetchAllSuggestedEditsSync),
			("testFetchAllSuggestedEditsAsync", testFetchAllSuggestedEditsAsync),
			
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
		XCTAssertNotNil(client, "client should not be nil")
		
		let expectedHost = "api.stackexchange.com"
		let expectedPath = "/2.2/info"
		let expectedParameters = ["site":"stackoverflow", "filter":"default"]
		
		client.defaultSite = "stackoverflow"
		client.defaultFilter = "default"
		client.onRequest {task in
			let url: URL! = task.currentRequest?.url
			XCTAssertNotNil(url, "url should not be nil")
			
			let actualHost = url.host
			let actualPath = url.path
			let actualParameters = self.parameters(from: url)
			XCTAssertEqual(expectedHost, actualHost)
			XCTAssertEqual(expectedPath, actualPath)
			XCTAssertEqual(expectedParameters, actualParameters)
			
			return ("{}".data(using: .utf8), self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest("info") as APIResponse<Site>
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
		
		let _ = try client.performAPIRequest("info", parameters: ["page":"1"]) as APIResponse<Site>
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
		
		let _ = try client.performAPIRequest("info", parameters: parameters) as APIResponse<Site>
		//not actually a Site, but Info isn't implemented yet.
	}
	
	
	
	func testQuota() throws {
		let expectedQuota = 123
		let expectedMaxQuota = 456
		client.onRequest {task in
			let responseJSON =
			"{\"has_more\": false, \"items\": [], \"quota_remaining\": \(expectedQuota), \"quota_max\": \(expectedMaxQuota)}"
			
			return (responseJSON.data(using: .utf8)!, self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest("info") as APIResponse<Site>
		
		XCTAssert(client.quota == expectedQuota,
		          "quota \"\(String(describing: client.quota))\" is incorrect (should be \"\(expectedQuota)\")")
		
		XCTAssert(client.maxQuota == expectedMaxQuota,
		          "quotaMax \"\(String(describing: client.maxQuota))\" is incorrect (should be \"\(expectedMaxQuota)\")")
	}
	
	
	let backoffTime: TimeInterval = 1
	
	
	func prepareBackoff(_ request: String = "info") throws {
		client.onRequest {task in
			let responseJSON = "{\"backoff\": \(Int(self.backoffTime))}"
			
			return (responseJSON.data(using: .utf8), self.blankResponse(task), nil)
		}
		
		let _ = try client.performAPIRequest(request) as APIResponse<Site>
		
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
		
		XCTAssertThrowsError(try client.performAPIRequest("info", backoffBehavior: .throwError) as APIResponse<Site>)
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
		let _ = try client.performAPIRequest("info", backoffBehavior: .wait) as APIResponse<Site>
		
		//make sure the backoff is cleaned up
		XCTAssertNil(client.backoffs["info"], "backoff was not cleaned up after waiting")
	}
	
	func testComplexRequestBackoff() throws {
		try prepareBackoff("/questions/123456")
		
		XCTAssertThrowsError(try client.performAPIRequest("questions/123457", backoffBehavior: .throwError) as APIResponse<Site>)
	}
	
	func testBackoffCleanup() throws {
		try prepareBackoff()
		
		client.backoffs["info"] = Date.distantPast
		let _ = try client.performAPIRequest("users/1") as APIResponse<User>
		XCTAssertNil(client.backoffs["info"], "backoff was not cleaned up")
	}
	
    
    // - MARK: Sites
	
	
	func testFetchSitesSync() {
		client.onRequest { task in
			return ("{\"items\": [{\"name\": \"Test Site\"}]}".data(using: .utf8), self.blankResponse(task), nil)
		}
		//not working yet. Just to show how to use the test method
		do {
			let response = try client.fetchSites()
			XCTAssertNotNil(response.items, "items is nil")
			XCTAssertEqual(response.items?.first?.name, "Test Site", "name was incorrect")
			
		} catch {
			print(error)
			XCTFail("fetchSites threw an error")
		}
	}
    
    func testFetchSitesAsync() {
        expectation = expectation(description: "Fetched sites")
        
        client.onRequest { task in
            return ("{\"items\": [{\"name\": \"Test Site\"}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchSites(parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Sites not fetched")
                return
            }
			
			if response?.items?.first?.name == "Test Site" {
				self.expectation?.fulfill()
			} else {
				print(response?.items ?? "no items")
				XCTFail("name was incorrect")
			}
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    // - MARK: Revisions
    
    func testFetchRevisionsSync() {
        let guid = "cc7cba9d-8eaa-4178-971d-4a678e7c430c"
        client.onRequest { task in
            return ("{\"items\": [{\"revision_type\": \"single_user\", \"revision_guid\": \"\(guid)\"}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchRevision(guid, parameters: [:], backoffBehavior: .wait)
            XCTAssertEqual(guid, response.items?[0].revision_guid, "guid was incorrect")
        }  catch {
            print(error)
            XCTFail("fetchRevision threw an error")
        }
    }
    
    func testFetchRevisionAsync() {
        expectation = expectation(description: "Fetched revision")
        
        let guid = "cc7cba9d-8eaa-4178-971d-4a678e7c430c"
        client.onRequest { task in
            return ("{\"items\": [{\"revision_type\": \"single_user\", \"revision_guid\": \"\(guid)\"}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchRevision(guid, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Revision not fetched")
                return
            }
            
            if (response?.items?[0].revision_guid)! == guid {
                self.expectation?.fulfill()
            } else {
                XCTFail("guids not equal")
            }
        }
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    
    
    // - MARK: Suggested edits
    
    func testFetchSuggestedEditsSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"title\": \"Just a test title\", \"suggested_edit_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchSuggestedEdit(id, parameters: [:], backoffBehavior: .wait)
            XCTAssertEqual(id, response.items?[0].suggested_edit_id, "id was incorrect")
        }  catch {
            print(error)
            XCTFail("fetchSuggestedEdit threw an error")
        }
    }
    
    func testFetchSuggestedEditsAsync() {
        expectation = expectation(description: "Fetched suggested edit")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"suggested_edit_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchSuggestedEdit(id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("SuggestedEdit not fetched")
                return
            }
            
            if (response?.items?[0].suggested_edit_id)! == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("ids not equal")
            }
        }
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testFetchAllSuggestedEditsSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"title\": \"Just a test title\", \"suggested_edit_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchSuggestedEdits()
            XCTAssertEqual(id, response.items?[0].suggested_edit_id, "id was incorrect")
        }  catch {
            print(error)
            XCTFail("fetchSuggestedEdits threw an error")
        }
    }
    
    func testFetchAllSuggestedEditsAsync() {
        expectation = expectation(description: "Fetched suggested edits")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"suggested_edit_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchSuggestedEdits(parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("SuggestedEdit not fetched")
                return
            }
            
            if (response?.items?[0].suggested_edit_id)! == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("ids not equal")
            }
        }
        
        waitForExpectations(timeout: 20, handler: nil)
    }
	
}
