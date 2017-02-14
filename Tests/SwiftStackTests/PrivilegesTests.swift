//
//  PrivilegesTests.swift
//  SwiftStack
//
//  Created by FelixSFD on 14.02.17.
//
//

import XCTest
import SwiftStack

class PrivilegesTests: APITests {
    
    
    func testFetchPrivilegesSync() {
        client.onRequest { task in
            return ("{\"items\": [{\"reputation\": 25000, \"description\": \"Access to internal and Google site analytics\", \"short_description\": \"access to site analytics\"}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchPrivileges()
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.reputation, 25000, "rep was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchPrivileges threw an error")
        }
    }
    
    func testFetchPrivilegesAsync() {
        expectation = expectation(description: "Fetched privileges")
        
        client.onRequest { task in
            return ("{\"items\": [{\"reputation\": 25000, \"description\": \"Access to internal and Google site analytics\", \"short_description\": \"access to site analytics\"}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchPrivileges(parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Privileges not fetched")
                return
            }
            
            print(response?.items ?? "no items")
            
            if response?.items?.first?.reputation == 25000 {
                self.expectation?.fulfill()
            } else {
                XCTFail("rep was incorrect")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
