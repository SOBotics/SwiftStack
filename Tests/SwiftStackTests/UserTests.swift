//
//  UserTests.swift
//  SwiftStack
//
//  Created by FelixSFD on 03.12.16.
//
//

import XCTest
import SwiftStack

class UserTests: XCTestCase {
    
    func testUserInitialization() {
        let user = User(type: .full)
        
        XCTAssert(user.type == .full)
    }
    
    func testUserFromJson() {
        let json = "{\"badge_counts\": {\"bronze\": 3,\"silver\": 2,\"gold\": 1},\"view_count\": 1000,\"down_vote_count\": 50,\"up_vote_count\": 90,\"answer_count\": 10,\"question_count\": 12,\"account_id\": 1,\"is_employee\": false,\"last_modified_date\": 1480858104,\"last_access_date\": 1480901304,\"age\": 40,\"reputation_change_year\": 9001,\"reputation_change_quarter\": 400,\"reputation_change_month\": 200,\"reputation_change_week\": 800,\"reputation_change_day\": 100,\"reputation\": 9001,\"creation_date\": 1480858104,\"user_type\": \"registered\",\"user_id\": 1,\"accept_rate\": 55,\"about_me\": \"about me block\",\"location\": \"An Imaginary World\",\"website_url\": \"http://example.com/\",\"link\": \"http://example.stackexchange.com/users/1/example-user\",\"profile_image\": \"https://www.gravatar.com/avatar/a007be5a61f6aa8f3e85ae2fc18dd66e?d=identicon&r=PG\",\"display_name\": \"Example User\"}"
        
        let user = User(jsonString: json)
        //print(user ?? "nil")
        
        if user?.jsonString == nil {
            XCTFail("User could not be represented as JSON!")
        }
        
        XCTAssertNotNil(user)
    }
    
}
