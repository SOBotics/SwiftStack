//
//  Comment.swift
//  SwiftStack
//
//  Created by FelixSFD on 07.12.16.
//
//

import Foundation

/**
 Represents a comment to a `Post`.
 
 - author: FelixSFD
 
 - seealso: [StackExchange API](https://api.stackexchange.com/docs/types/comment)
 */
public class Comment: JsonConvertible {
    
    // - MARK: Initializers
    
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
        self.can_flag = dictionary["can_flag"] as? Bool
        self.comment_id = dictionary["comment_id"] as? Int
        
        if let timestamp = dictionary["creation_date"] as? Double {
            self.creation_date = Date(timeIntervalSince1970: timestamp)
        }
        
        self.edited = dictionary["edited"] as? Bool
        
        if let urlString = dictionary["link"] as? String {
            self.link = URL(string: urlString)
        }
        
        if let user = dictionary["owner"] as? [String: Any] {
            self.owner = User(dictionary: user)
        }
        
        self.post_id = dictionary["post_id"] as? Int
        
        if let postTypeRaw = dictionary["post_type"] as? String {
            self.post_type = Post.PostType(rawValue: postTypeRaw)
        }
        
        if let user = dictionary["reply_to_user"] as? [String: Any] {
            self.reply_to_user = User(dictionary: user)
        }
        
        self.score = dictionary["score"] as? Int
        self.upvoted = dictionary["upvoted"] as? Bool
    }
    
    // - MARK: JsonConvertible
    
    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        
        dict["body"] = body
        dict["body_markdown"] = body_markdown
        dict["can_flag"] = can_flag
        dict["comment_id"] = comment_id
        dict["creation_date"] = creation_date
        dict["edited"] = edited
        dict["link"] = link
        dict["owner"] = owner?.dictionary
        dict["post_id"] = post_id
        dict["post_type"] = post_type
        dict["reply_to_user"] = reply_to_user?.dictionary
        dict["score"] = score
        dict["upvoted"] = upvoted
        
        return dict
    }
    
    public var jsonString: String? {
        return (try? JsonHelper.jsonString(from: self)) ?? nil
    }
    
    
    // - MARK: Fields
    
    public var body: String?
    
    public var body_markdown: String?
    
    public var can_flag: Bool?
    
    public var comment_id: Int?
    
    public var creation_date: Date?
    
    public var edited: Bool?
    
    public var link: URL?
    
    public var owner: User?
    
    public var post_id: Int?
    
    public var post_type: Post.PostType?
    
    public var reply_to_user: User?
    
    public var score: Int?
    
    public var upvoted: Bool?
    
    
}
