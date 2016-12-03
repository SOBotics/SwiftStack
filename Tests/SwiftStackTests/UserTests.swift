//
//  UserTests.swift
//  SwiftStack
//
//  Created by Felix Deil on 03.12.16.
//
//

import XCTest
import SwiftStack

class UserTests: XCTestCase {
    
    func testUserInitialization() {
        let user = User(type: .full)
        
        XCTAssert(user.type == .full)
    }
    
}
