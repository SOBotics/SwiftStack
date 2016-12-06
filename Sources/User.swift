//
//  User.swift
//  SwiftStack
//
//  Created by FelixSFD on 02.12.16.
//
//

import Foundation

/**
 Represents a user on StackExchange.
 
 - author: FelixSFD
 
 - seealso: [StackExchange API](https://api.stackexchange.com/docs/types/user)
 */
public class User {
    
    // - MARK: The user-type
    
    /**
     The tpye of the user. The StackExchange API returns different types of users depending on the use-case.
     
     - author: FelixSFD
     */
    public enum UserInfoType: String {
        /**
         This user-type can contain all available properties
         */
        case full = "full_user"
        case shallow = "shallow_user"
        case network = "network_user"
        
        /**
         This user-type could contain anything, but most likely, it is not initialized correctly.
         */
        case undefined = "undefined"
        
        /**
         Initializes the enum with `.undefined` as default value.
         */
        public init() {
            self = .undefined
        }
    }
    
    /**
     The type of the user/account as returned form the API.
     
     - author: FelixSFD
     
     - seealso: [StackExchange API](https://api.stackexchange.com/docs/types/user)
     */
    public enum UserType: String {
        case unregistered = "unregistered"
        case registered = "registered"
        case moderator = "moderator"
        case doesNotExist = "does_not_exist"
    }
    
    // - MARK: Public properties
    
    /**
     The `User.UserType` of the user.
     
     This does not affect the other properties. It's just for the developers to see, which data they can expect.
     */
    public var type = User.UserInfoType.undefined
    
    
    // - MARK: Initializers
    
    /**
     Simple initializer with an `UserInfoType` as possible parameter.
     
     - parameter type: The `UserType` the new instance should have
     
     - author: FelixSFD
     */
    public init(type: UserInfoType) {
        self.type = type
    }
    
    /**
     Initializes the object from a JSON string.
     
     - parameter json: The JSON string returned by the API
     
     - author: FelixSFD
     */
    public init?(jsonString json: String) {
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [String: Any] else {
                return nil
            }
                        
            self.about_me = dictionary["about_me"] as? String
            self.accept_rate = dictionary["accept_rate"] as? Int
            self.account_id = dictionary["account_id"] as? Int
            self.age = dictionary["age"] as? Int
            self.answer_count = dictionary["answer_count"] as? Int
            
            if let badgeCounts = dictionary["badge_counts"] as? [String: Any] {
                if let badges = BadgeCount(dictionary: badgeCounts) {
                    self.badge_counts = badges
                }
            }
            
            if let creationTimestamp = dictionary["creation_date"] as? Double {
                self.creation_date = Date(timeIntervalSince1970: creationTimestamp)
            }
            
            self.display_name = dictionary["display_name"] as? String
            self.down_vote_count = dictionary["down_vote_count"] as? Int
            self.is_employee = dictionary["is_employee"] as? Bool
            
            if let lastAccessTimestamp = dictionary["last_access_date"] as? Double {
                self.last_access_date = Date(timeIntervalSince1970: lastAccessTimestamp)
            }
            
            if let lastModifiedTimestamp = dictionary["last_modified_date"] as? Double {
                self.last_modified_date = Date(timeIntervalSince1970: lastModifiedTimestamp)
            }
            
            if let urlString = dictionary["link"] as? String {
                self.link = URL(string: urlString)
            }
            
            self.location = dictionary["location"] as? String
            
            if let urlString = dictionary["profile_image"] as? String {
                self.link = URL(string: urlString)
            }
            
            self.question_count = dictionary["question_count"] as? Int
            self.reputation = dictionary["reputation"] as? Int
            self.reputation_change_day = dictionary["reputation_change_day"] as? Int
            self.reputation_change_week = dictionary["reputation_change_week"] as? Int
            self.reputation_change_month = dictionary["reputation_change_month"] as? Int
            self.reputation_change_quarter = dictionary["reputation_change_quarter"] as? Int
            self.reputation_change_year = dictionary["reputation_change_year"] as? Int
            
            if let timedPenaltyTimestamp = dictionary["timed_penalty_date"] as? Double {
                self.timed_penalty_date = Date(timeIntervalSince1970: timedPenaltyTimestamp)
            }
            
            self.up_vote_count = dictionary["up_vote_count"] as? Int
            self.user_id = dictionary["user_id"] as? Int
            
            if let userTypeString = dictionary["user_type"] as? String {
                self.user_type = UserType(rawValue: userTypeString)
            }
            
            self.view_count = dictionary["view_count"] as? Int
            self.website_url = dictionary["website_url"] as? String
            
            
        } catch {
            return nil
        }
    }
    
    /**
     Basic initializer without any parameters
     */
    public init() { }
    
    
    
    // - MARK: Values returned from API
    
    public var about_me: String?
    
    public var accept_rate: Int?
    
    public var account_id: Int?
    
    public var age: Int?
    
    public var answer_count: Int?
    
    public var badge_counts: BadgeCount?
    
    public var creation_date: Date?
    
    public var display_name: String?
    
    public var down_vote_count: Int?
    
    public var is_employee: Bool?
    
    public var last_access_date: Date?
    
    public var last_modified_date: Date?
    
    public var link: URL?
    
    public var location: String?
    
    public var profile_image: URL?
    
    public var question_count: Int?
    
    public var reputation: Int?
    
    public var reputation_change_day: Int?
    
    public var reputation_change_month: Int?
    
    public var reputation_change_quarter: Int?
    
    public var reputation_change_week: Int?
    
    public var reputation_change_year: Int?
    
    public var timed_penalty_date: Date?
    
    public var up_vote_count: Int?
    
    public var user_id: Int?
    
    public var user_type: UserType?
    
    public var view_count: Int?
    
    public var website_url: String?
    
}
