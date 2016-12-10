//
//  Question.swift
//  SwiftStack
//
//  Created by FelixSFD on 06.12.16.
//
//

import Foundation

/**
 This class represents a question with all fields, the API can return.
 
 - author: FelixSFD
 
 - seealso: [StackExchange API](https://api.stackexchange.com/docs/types/question)
 */
public class Question: Post {
    
    // - MARK: Closed details
    
    /**
     This type represents details about a question closure.
     
     - author: FelixSFD
     */
    public struct ClosedDetails: JsonConvertible {
        
        // - MARK: Initializers
        
        public init?(jsonString json: String) {
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String: Any] else {
                    return nil
                }
                
                self.init(dictionary: dictionary)
            } catch {
                return nil
            }
        }
        
        public init(dictionary: [String: Any]) {
            if let users = dictionary["by_users"] as? [[String: Any]] {
                var tmpUsers = [User]()
                for user in users {
                    let tmpUser = User(dictionary: user)
                    tmpUsers.append(tmpUser)
                }
                
                if tmpUsers.count > 0 {
                    self.by_users = tmpUsers
                }
            }
            
            self.description = dictionary["description"] as? String
            self.on_hold = dictionary["on_hold"] as? Bool
            
            if let questionsArray = dictionary["original_questions"] as? [[String: Any]] {
                var questionsTmp = [Question]()
                
                for question in questionsArray {
                    let questionTmp = Question(dictionary: question)
                    questionsTmp.append(questionTmp)
                }
            }
            
            self.reason = dictionary["reason"] as? String
        }
        
        // - MARK: JsonConvertible
        
        public var dictionary: [String: Any] {
            var dict = [String: Any]()
                        
            if by_users != nil && (by_users?.count)! > 0 {
                var tmpUsers = [[String: Any]]()
                for user in by_users! {
                    tmpUsers.append(user.dictionary)
                }
                
                dict["by_users"] = tmpUsers
            }
            
            dict["description"] = description
            dict["on_hold"] = on_hold
            dict["original_questions"] = original_questions
            dict["reason"] = reason
            
            return dict
        }
        
        public var jsonString: String? {
            return (try? JsonHelper.jsonString(from: self)) ?? nil
        }
        
        // - MARK: Fields
        
        public var by_users: [User]?
        
        public var description: String?
        
        public var on_hold: Bool?
        
        public var original_questions: [Question]?
        
        public var reason: String?
    }
    
    
    // - MARK: Migration info
    
    /**
     This type represents a question's migration to or from a different site in the Stack Exchange network
     */
    public struct MigrationInfo: JsonConvertible {
        
        // - MARK: Initializers
        
        public init?(jsonString json: String) {
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String: Any] else {
                    return nil
                }
                
                self.init(dictionary: dictionary)
            } catch {
                return nil
            }
        }
        
        public init?(dictionary: [String : Any]) {
            if let timestamp = dictionary["on_date"] as? Double {
                self.on_date = Date(timeIntervalSince1970: timestamp)
            }
            
            if let site = dictionary["other_site"] as? [String: Any] {
                self.other_site = Site(dictionary: site)
            }
            
            self.question_id = dictionary["question_id"] as? Int
        }
        
        // - MARK: JsonConvertible
        
        public var dictionary: [String: Any] {
            var dict = [String: Any]()
            
            dict["on_date"] = on_date
            dict["other_site"] = other_site?.dictionary
            dict["question_id"] = question_id
            
            return dict
        }
        
        public var jsonString: String? {
            return (try? JsonHelper.jsonString(from: self)) ?? nil
        }
        
        // - MARK: Fields
        
        public var on_date: Date?
        
        public var other_site: Site?
        
        public var question_id: Int?
        
    }
    
    
    // - MARK: Initializers
    
    /**
     Initializes the object from a JSON string.
     
     - parameter json: The JSON string returned by the API
     
     - author: FelixSFD
     */
    public required convenience init?(jsonString json: String) {
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String: Any] else {
                return nil
            }
            
            self.init(dictionary: dictionary)
        } catch {
            return nil
        }
    }
    
    public required init(dictionary: [String: Any]) {
        super.init(dictionary: dictionary)
        
        //only set the new properties here. The rest is managed by the superclass
        
        self.accepted_answer_id = dictionary["accepted_answer_id"] as? Int
        self.answer_count = dictionary["answer_count"] as? Int
        
        if let answers = dictionary["answers"] as? [[String: Any]] {
            var tmpAnswers = [Answer]()
            
            for answer in answers {
                let tmpAnswer = Answer(dictionary: answer)
                tmpAnswers.append(tmpAnswer)
            }
            
            if tmpAnswers.count > 0 {
                self.answers = tmpAnswers
            }
        }
        
        self.bounty_amount = dictionary["bounty_amount"] as? Int
        
        if let timestamp = dictionary["bounty_closes_date"] as? Double {
            self.bounty_closes_date = Date(timeIntervalSince1970: timestamp)
        }
        
        if let user = dictionary["bounty_user"] as? [String: Any] {
            self.bounty_user = User(dictionary: user)
        }
        
        self.can_close = dictionary["can_close"] as? Bool
        self.can_flag = dictionary["can_flag"] as? Bool
        self.close_vote_count = dictionary["close_vote_count"] as? Int
        
        if let timestamp = dictionary["closed_date"] as? Double {
            self.closed_date = Date(timeIntervalSince1970: timestamp)
        }
        
        if let closedDetailsDict = dictionary["closed_details"] as? [String: Any] {
            self.closed_details = ClosedDetails(dictionary: closedDetailsDict)
        }
        
        
        self.closed_reason = dictionary["closed_reason"] as? String
        
        if let timestamp = dictionary["community_owned_date"] as? Double {
            self.community_owned_date = Date(timeIntervalSince1970: timestamp)
        }
        
        if let timestamp = dictionary["creation_date"] as? Double {
            self.creation_date = Date(timeIntervalSince1970: timestamp)
        }
        
        self.delete_vote_count = dictionary["delete_vote_count"] as? Int
        self.favorite_count = dictionary["favorite_count"] as? Int
        self.favorited = dictionary["favorites"] as? Bool
        self.is_answered = dictionary["is_answered"] as? Bool
        
        if let timestamp = dictionary["locked_date"] as? Double {
            self.locked_date = Date(timeIntervalSince1970: timestamp)
        }
        
        if let migration = dictionary["migrated_from"] as? [String: Any] {
            self.migrated_from = MigrationInfo(dictionary: migration)
        }
        
        if let migration = dictionary["migrated_to"] as? [String: Any] {
            self.migrated_to = MigrationInfo(dictionary: migration)
        }
                
        if let noticeArray = dictionary["notice"] as? [String: Any] {
            self.notice = Notice(dictionary: noticeArray)
        }
        
        if let timestamp = dictionary["protected_date"] as? Double {
            self.protected_date = Date(timeIntervalSince1970: timestamp)
        }
        
        self.question_id = dictionary["question_id"] as? Int
        self.reopen_vote_count = dictionary["reopen_vote_count"] as? Int
        self.tags = dictionary["tags"] as? [String]
        
        self.view_count = dictionary["view_count"] as? Int
    }
    
    
    // - MARK: JsonConvertible
    
    public override var dictionary: [String: Any] {
        var dict = super.dictionary
        
        dict["accepted_answer_id"] = accepted_answer_id
        dict["answer_count"] = answer_count
        
        if answers != nil && (answers?.count)! > 0 {
            var tmpAnswers = [[String: Any]]()
            for answer in answers! {
                tmpAnswers.append(answer.dictionary)
            }
            
            dict["answers"] = tmpAnswers
        }
        
        dict["bounty_amount"] = bounty_amount
        dict["bounty_user"] = bounty_user?.dictionary
        dict["can_close"] = can_close
        dict["can_flag"] = can_flag
        dict["close_vote_count"] = close_vote_count
        dict["closed_date"] = closed_date
        dict["closed_details"] = closed_details?.dictionary
        dict["closed_reason"] = closed_reason
        dict["community_owned_date"] = community_owned_date
        dict["creation_date"] = creation_date
        dict["delete_vote_count"] = delete_vote_count
        dict["favorite_count"] = favorite_count
        dict["favorited"] = favorited
        dict["is_answered"] = is_answered
        dict["locked_date"] = locked_date
        dict["migrated_from"] = migrated_from?.dictionary
        dict["migrated_to"] = migrated_to?.dictionary
        dict["notice"] = notice?.dictionary
        dict["protected_date"] = protected_date
        dict["question_id"] = question_id
        dict["reopen_vote_count"] = reopen_vote_count
        dict["tags"] = tags
        dict["view_count"] = view_count
        
        return dict
    }
    
    
    
    // - MARK: Properties returned from API
    
    public var accepted_answer_id: Int?
    
    public var answer_count: Int?
    
    public var answers: [Answer]?
    
    public var bounty_amount: Int?
    
    public var bounty_closes_date: Date?
    
    public var bounty_user: User?
    
    public var can_close: Bool?
    
    public var can_flag: Bool?
    
    public var close_vote_count: Int?
    
    public var closed_date: Date?
    
    public var closed_details: ClosedDetails?
    
    public var closed_reason: String?
    
    public var community_owned_date: Date?
    
    public var creation_date: Date?
    
    public var delete_vote_count: Int?
    
    public var favorite_count: Int?
    
    public var favorited: Bool?
    
    public var is_answered: Bool?
    
    public var locked_date: Date?
    
    public var migrated_from: MigrationInfo?
    
    public var migrated_to: MigrationInfo?
    
    public var notice: Notice?
    
    public var protected_date: Date?
    
    public var question_id: Int?
    
    public var reopen_vote_count: Int?
    
    public var tags: [String]?
    
    public var view_count: Int?
    
    
    
    
}
