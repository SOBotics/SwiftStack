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
public class Post: JsonConvertible, CustomStringConvertible {
    
    // - MARK: The type of the post
    
    /**
     Defines the type of a post. Either a question or an answer
     
     - author: FelixSFD
     */
    public enum PostType: String, StringRepresentable {
        case answer = "answer"
        case question = "question"
    }
    
    // - MARK: Post.Notice
    
    /**
     Represents a notice on a post.
     
     - author: FelixSFD
     */
    public struct Notice: JsonConvertible {
        
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
        
        public var dictionary: [String: Any] {
            var dict = [String: Any]()
            
            dict["body"] = body
            dict["creation_date"] = creation_date
            dict["owner_user_id"] = owner_user_id
            
            return dict
        }
        
        public var jsonString: String? {
            return (try? JsonHelper.jsonString(from: self)) ?? nil
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
        
        if let user = dictionary["last_editor"] as? [String: Any] {
            self.last_editor = User(dictionary: user)
        }
        
        if let urlString = dictionary["link"] as? String {
            self.link = URL(string: urlString)
        }
        
        if let user = dictionary["owner"] as? [String: Any] {
            self.owner = User(dictionary: user)
        }
        
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
    
    
    // - MARK: JsonConvertible
    
    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        
        dict["body"] = body
        dict["body_markdown"] = body_markdown
        dict["comment_count"] = comment_count
        dict["comments"] = comments
        dict["down_vote_count"] = down_vote_count
        dict["downvoted"] = downvoted
        dict["down_vote_count"] = down_vote_count
        dict["last_activity_date"] = last_activity_date
        dict["last_edit_date"] = last_edit_date
        dict["last_editor"] = last_editor?.dictionary
        dict["link"] = link
        dict["owner"] = owner?.dictionary
        dict["post_id"] = post_id
        dict["post_type"] = post_type
        dict["score"] = score
        dict["share_link"] = share_link
        dict["title"] = title
        dict["up_vote_count"] = up_vote_count
        dict["upvoted"] = upvoted
        
        return dict
    }
    
    public var jsonString: String? {
        return (try? JsonHelper.jsonString(from: self)) ?? nil
    }
    
    // - MARK: CustomStrinConvertible
    
    public var description: String {
        return "\(dictionary)"
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
    
    public var last_editor: User?
    
    public var link: URL?
    
    public var owner: User?
    
    public var post_id: Int?
    
    public var post_type: PostType?
    
    public var score: Int?
    
    public var share_link: URL?
    
    public var title: String?
    
    public var up_vote_count: Int?
    
    public var upvoted: Bool?
    
}
