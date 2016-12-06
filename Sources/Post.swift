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
    
    // - MARK: Initializers
    
    /**
     Basic initializer without default values
     */
    public init() {
        
    }
    
    
    // - MARK: Properties returned from API
    
    public var body: String?
    
    public var body_markdown: String?
    
    public var comment_count: Int?
    
    //NOTE: Add comment class
    public var comments: [Any]?
    
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
