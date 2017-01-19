//
//  AnswersTests.swift
//  SwiftStack
//
//  Created by FelixSFD on 14.01.17.
//
//

import XCTest

class AnswersTests: APITests {
    
    // - MARK: Test answers
    
    func testFetchAnswerSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"answer_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchAnswer(id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.post_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchAnswer threw an error")
        }
    }
    
    func testFetchAnswerAsync() {
        expectation = expectation(description: "Fetched answer")
        
        let id = 13371337
        
        client.onRequest { task in
            return ("{\"items\": [{\"answer_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchAnswer(id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Answer not fetched")
                return
            }
            
            print(response?.items ?? "no items")
            
            if response?.items?.first?.answer_id == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("id was incorrect")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    // - MARK: Test all answers
    
    func testFetchAllAnswersSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"answer_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchAnswers()
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.answer_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchAnswers threw an error")
        }
    }
    
    func testFetchAllAnswersAsync() {
        expectation = expectation(description: "Fetched answers")
        
        let id = 13371337
        
        client.onRequest { task in
            return ("{\"items\": [{\"answer_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchAnswers(parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Answers not fetched")
                return
            }
            
            print(response?.items ?? "no items")
            
            if response?.items?.first?.answer_id == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("id was incorrect")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    // - MARK: Test questions of answers
    
    func testFetchQuestionOfAnswerSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchQuestionOfAnswer(id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.question_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchQuestion threw an error")
        }
    }
    
    func testFetchQuestionOfAnswerAsync() {
        expectation = expectation(description: "Fetched question")
        
        let id = 13371337
        
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchQuestionOfAnswer(id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Question not fetched")
                return
            }
            
            print(response?.items ?? "no items")
            
            if response?.items?.first?.question_id == id {
                self.expectation?.fulfill()
            } else {
                XCTFail("id was incorrect")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
