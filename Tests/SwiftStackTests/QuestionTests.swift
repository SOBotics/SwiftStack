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
    
    
    // - MARK: Test answers on question
    
    func testFetchAnswersOnQuestionSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"answer_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchAnswersOn(question: id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.answer_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchAnswersOn(question:) threw an error")
        }
    }
    
    func testFetchAnswersOnQuestionAsync() {
        expectation = expectation(description: "Fetched answers")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"answer_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchAnswersOn(question: id, parameters: [:], backoffBehavior: .wait) {
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
    
    
    // - MARK: Test linked questions
    
    func testFetchLinkedQuestionsSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchLinkedQuestionsTo(question: id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.question_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchLinkedQuestionsTo(question:) threw an error")
        }
    }
    
    func testFetchLinkedQuestionsAsync() {
        expectation = expectation(description: "Fetched questions")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchLinkedQuestionsTo(question: id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Questions not fetched")
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
    
    // - MARK: Test related questions
    
    func testFetchRelatedQuestionsSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchRelatedQuestionsTo(question: id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.question_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchRelatedQuestionsTo(question:) threw an error")
        }
    }
    
    func testFetchRelatedQuestionsAsync() {
        expectation = expectation(description: "Fetched questions")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchRelatedQuestionsTo(question: id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Questions not fetched")
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
    
    
    // - MARK: Test featured questions
    
    func testFetchFeaturedQuestionsSync() {
        let bounty = 100
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id), \"bounty_amount\": \(bounty)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchFeaturedQuestions()
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.post_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchFeaturedQuestions threw an error")
        }
    }
    
    func testFetchFeaturedQuestionAsync() {
        expectation = expectation(description: "Fetched questions")
        
        let bounty = 100
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id), \"bounty_amount\": \(bounty)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchFeaturedQuestions(parameters: [:], backoffBehavior: .wait) {
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
    
    
    
    // - MARK: Test timeline of questions
    
    func testFetchQuestionsTimelineSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchTimelineOf(question: id)
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.question_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchTimelineOf threw an error")
        }
    }
    
    func testFetchQuestionsTimelineAsync() {
        expectation = expectation(description: "Fetched timeline")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchTimelineOf(question: id, parameters: [:], backoffBehavior: .wait) {
            response, error in
            if error != nil {
                print(error!)
                XCTFail("Timeline not fetched")
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
    
    
    
    // - MARK: Test questions with no answers
    
    func testFetchQuestionsWithNoAnswersSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchQuestionsWithNoAnswers()
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.post_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchQuestionsWithNoAnswers threw an error")
        }
    }
    
    func testFetchQuestionsWithNoAnswersAsync() {
        expectation = expectation(description: "Fetched questions")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchQuestionsWithNoAnswers(parameters: [:], backoffBehavior: .wait) {
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
    
    
    
    // - MARK: Test unanswered questions
    
    func testFetchUnansweredQuestionsSync() {
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        do {
            let response = try client.fetchUnansweredQuestions()
            XCTAssertNotNil(response.items, "items is nil")
            XCTAssertEqual(response.items?.first?.post_id, id, "id was incorrect")
            
        } catch {
            print(error)
            XCTFail("fetchQuestionsWithNoAnswers threw an error")
        }
    }
    
    func testFetchUnansweredQuestionsAsync() {
        expectation = expectation(description: "Fetched questions")
        
        let id = 13371337
        client.onRequest { task in
            return ("{\"items\": [{\"question_id\": \(id)}]}".data(using: .utf8), self.blankResponse(task), nil)
        }
        
        client.fetchUnansweredQuestions(parameters: [:], backoffBehavior: .wait) {
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
    
}
