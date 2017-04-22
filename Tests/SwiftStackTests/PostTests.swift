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
        let json = "{\"tags\": [\"windows\",\"c#\",\".net\"],\"owner\": {\"reputation\": 9001,\"user_id\": 1,\"user_type\": \"registered\",\"accept_rate\": 55,\"profile_image\": \"https://www.gravatar.com/avatar/a007be5a61f6aa8f3e85ae2fc18dd66e?d=identicon&r=PG\",\"display_name\": \"Example User\",\"link\": \"http://example.stackexchange.com/users/1/example-user\"},\"is_answered\": false,\"view_count\": 31415,\"favorite_count\": 1,\"down_vote_count\": 2,\"up_vote_count\": 3,\"answer_count\": 0,\"score\": 1,\"last_activity_date\": 1481043116,\"creation_date\": 1480999916,\"last_edit_date\": 1481068316,\"question_id\": 1234,\"link\": \"http://example.stackexchange.com/questions/1234/an-example-post-title\",\"title\": \"An example post title\",\"body\": \"An example post body\", \"migrated_from\": {\"other_site\": {\"launch_date\": 1481391367,\"open_beta_date\": 1481304967,\"closed_beta_date\": 1481218567,\"site_state\": \"normal\",\"icon_url\": \"http://sstatic.net/stackexchange/img/apple-touch-icon.png\",\"audience\": \"example lovers\",\"site_url\": \"http://example.stackexchange.com\",\"api_site_parameter\": \"example\",\"logo_url\": \"http://sstatic.net/stackexchange/img/logo.png\",\"name\": \"Example Site\",\"site_type\": \"main_site\"},\"on_date\": 1481304967,\"question_id\": 1}}"
        
        let question = Question(jsonString: json)
        let jsonQuestion = question?.jsonString
        //print(jsonQuestion ?? "nil")
        XCTAssertNotNil(jsonQuestion)
    }
    
    func testBasicAnswer() {
        let json = "{\"owner\": {\"reputation\": 9001,\"user_id\": 1,\"user_type\": \"registered\",\"accept_rate\": 55,\"profile_image\": \"https://www.gravatar.com/avatar/a007be5a61f6aa8f3e85ae2fc18dd66e?d=identicon&r=PG\",\"display_name\": \"Example User\",\"link\": \"http://example.stackexchange.com/users/1/example-user\"},\"down_vote_count\": 2,\"up_vote_count\": 3,\"is_accepted\": false,\"score\": 1,\"last_activity_date\": 1481316638,\"creation_date\": 1481273438,\"locked_date\": 1481338238,\"answer_id\": 5678,\"question_id\": 1234,\"link\": \"http://example.stackexchange.com/questions/1234/an-example-post-title/5678#5678\",\"title\": \"An example post title\",\"body\": \"An example post body\"}"
        
        let answer = Answer(jsonString: json)
        let jsonAnswer = answer?.jsonString
        //print(jsonAnswer ?? "nil")
        XCTAssertNotNil(jsonAnswer)
    }
    
}
