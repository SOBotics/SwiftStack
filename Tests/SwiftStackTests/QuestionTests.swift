//
//  QuestionTests.swift
//  SwiftStack
//
//  Created by Felix Deil on 04.01.17.
//
//

import XCTest

class QuestionTests: APITests {
    
    // - MARK: Test question
    
    func testFetchQuestionSync() {
        let id = 41463556
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchQuestion(id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.post_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchQuestion threw an error")
        }
    }
    
    func testFetchQuestionAsync() {
        expectation = expectation(description: "Fetched comments")
        
        let id = 41463556
        
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchQuestion(id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Question not fetched")
                return
            }
            
            print(response?.items ?? "no items")
            
            if response?.items?.first?.post_id == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("id was incorrect")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    // - MARK: Test all questions
    
    func testFetchAllQuestionSync() {
        let id = 41463556
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchQuestions()
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.post_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchQuestions threw an error")
        }
    }
    
    func testFetchAllQuestionAsync() {
        expectation = expectation(description: "Fetched comments")
        
        let id = 41463556
        
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchQuestions(parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Questions not fetched")
                return
            }
            
            print(response?.items ?? "no items")
            
            if response?.items?.first?.post_id == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("id was incorrect")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    
    // - MARK: Test comments on question
    
    func testFetchCommentsOnQuestionSync() {
        let id = 41463556
        client.onRequest { task in
            return ("{\"items\": [{\"post_id\": \(id), \"comment_id\": 13371337}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchCommentsOn(question: id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.post_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchCommentsOn(question:) threw an error")
        }
    }
    
    func testFetchCommentsOnQuestionAsync() {
        expectation = expectation(description: "Fetched comments")
        
        let id = 41463556
        
        client.onRequest { task in
            return ("{\"items\": [{\"post_id\": \(id), \"comment_id\": 13371337}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchCommentsOn(question: id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Comments not fetched")
                return
            }
            
            print(response?.items ?? "no items")
            
            if response?.items?.first?.post_id == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("id was incorrect")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
