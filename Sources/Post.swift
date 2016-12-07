//
//  Post.swift
//  SwiftStack
//
//  Created by FelixSFD on 06.12.16.
//
//

import Foundation

/**
 The base class of `Question`s and `Answer`s
 
 - author: FelixSFD
 
 - seealso: [StackExchange API](https://api.stackexchange.com/docs/types/post)
 */
public class Post {
    
    // - MARK: The type of the post
    
    /**
     Defines the type of a post. Either a question or an answer
     
     - author: FelixSFD
     */
    public enum PostType: String {
        case answer = "answer"
        case question = "question"
    }
    
    // - MARK: Post.Notice
    
    /**
     Represents a notice on a post.
     
     - author: FelixSFD
     */
    public struct Notice {
        
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
            self.body = dictionary["body"] as? String
            
            if let timestamp = dictionary["creation_date"] as? Double {
                self.creation_date = Date(timeIntervalSince1970: timestamp)
            }
            
            self.owner_user_id = dictionary["owner_user_id"] as? Int
        }
        
        
        public var body: String?
        public var creation_date: Date?
        public var owner_user_id: Int?
    }
    
    // - MARK: Initializers
    
    /**
     Basic initializer without default values
     */
    public init() {
        
    }
    
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
        self.body = dictionary["body"] as? String
        self.body_markdown = dictionary["body_markdown"] as? String
        self.comment_count = dictionary["comment_count"] as? Int
        
        if let commentsArray = dictionary["comments"] as? [[String: Any]] {
            var commentsTmp = [Comment]()
            
            for commentDictionary in commentsArray {
                let commentTmp = Comment(dictionary: commentDictionary)
                commentsTmp.append(commentTmp)
            }
        }
        
        self.down_vote_count = dictionary["down_vote_count"] as? Int
        self.downvoted = dictionary["downvoted"] as? Bool
        
        if let timestamp = dictionary["last_activity_date"] as? Double {
            self.last_activity_date = Date(timeIntervalSince1970: timestamp)
        }
        
        if let timestamp = dictionary["last_edit_date"] as? Double {
            self.last_edit_date = Date(timeIntervalSince1970: timestamp)
        }
        
        //self.last_editor = nil
        
        if let urlString = dictionary["link"] as? String {
            self.link = URL(string: urlString)
        }
        
        //self.owner = nil
        self.post_id = dictionary["post_id"] as? Int
        
        if let type = dictionary["post_type"] as? String {
            self.post_type = PostType(rawValue: type)
        }
                
        self.score = dictionary["score"] as? Int
        
        if let urlString = dictionary["share_link"] as? String {
            self.share_link = URL(string: urlString)
        }
        
        self.title = dictionary["title"] as? String
        self.up_vote_count = dictionary["up_vote_count"] as? Int
        self.upvoted = dictionary["upvoted"] as? Bool
    }
    
    
    // - MARK: Properties returned from API
    
    public var body: String?
    
    public var body_markdown: String?
    
    public var comment_count: Int?
    
    public var comments: [Comment]?
    
    public var down_vote_count: Int?
    
    public var downvoted: Bool?
    
    public var last_activity_date: Date?
    
    public var last_edit_date: Date?
    
    //NOTE: wait for pull reuqest #1
    public var last_editor: Any?
    
    public var link: URL?
    
    //NOTE: see above
    public var owner: Any?
    
    public var post_id: Int?
    
    public var post_type: PostType?
    
    public var score: Int?
    
    public var share_link: URL?
    
    public var title: String?
    
    public var up_vote_count: Int?
    
    public var upvoted: Bool?
    
}
