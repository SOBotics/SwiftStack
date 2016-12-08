//
//  PostTests.swift
//  SwiftStack
//
//  Created by FelixSFD on 07.12.16.
//
//

import XCTest
import SwiftStack

class PostTests: XCTestCase {
    
    func testBasicQuestion() {
        let json = "{\"tags\": [\"windows\",\"c#\",\".net\"],\"owner\": {\"reputation\": 9001,\"user_id\": 1,\"user_type\": \"registered\",\"accept_rate\": 55,\"profile_image\": \"https://www.gravatar.com/avatar/a007be5a61f6aa8f3e85ae2fc18dd66e?d=identicon&r=PG\",\"display_name\": \"Example User\",\"link\": \"http://example.stackexchange.com/users/1/example-user\"},\"is_answered\": false,\"view_count\": 31415,\"favorite_count\": 1,\"down_vote_count\": 2,\"up_vote_count\": 3,\"answer_count\": 0,\"score\": 1,\"last_activity_date\": 1481043116,\"creation_date\": 1480999916,\"last_edit_date\": 1481068316,\"question_id\": 1234,\"link\": \"http://example.stackexchange.com/questions/1234/an-example-post-title\",\"title\": \"An example post title\",\"body\": \"An example post body\"}"
        
        let question = Question(jsonString: json)
        print(question?.description)
        XCTAssertNotNil(question)
    }
    
}
