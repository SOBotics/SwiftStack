//
//  Question.swift
//  SwiftStack
//
//  Created by Felix Deil on 06.12.16.
//
//

import Foundation

public class Question: Post {
    
    
    // - MARK: Properties returned from API
    
    public var accepted_answer_id: Int?
    
    public var answer_count: Int?
    
    //NOTE: [Answer]
    public var answers: [Any]?
    
    public var bounty_amount: Int?
    
    public var bounty_closes_date: Date?
    
    //NOTE: Wait for PR #1
    public var bounty_user: Any?
    
    public var can_close: Bool?
    
    public var can_flag: Bool?
    
    public var close_vote_count: Int?
    
    public var closed_date: Date?
    
    //NOTE: closed_Details
    public var closed_details: Any?
    
    public var closed_reason: String?
    
    public var community_owned_date: Date?
    
    public var creation_date: Date?
    
    public var delete_vote_count: Int?
    
    public var favorite_count: Int?
    
    public var favorited: Bool?
    
    public var is_answered: Bool?
    
    public var locked_date: Date?
    
    //NOTE: migration info
    public var migrated_from: Any?
    
    public var migrated_to: Any?
    
    //NOTE: notice object
    public var notice: Any?
    
    public var protected_date: Date?
    
    public var question_id: Int?
    
    public var reopen_vote_count: Int?
    
    public var tags: [String]?
    
    public var view_count: Int?
    
    
    
    
}
