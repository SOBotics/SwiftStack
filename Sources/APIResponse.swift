//
//  APIResponse.swift
//  SwiftStack
//
//  Created by FelixSFD on 11.12.16.
//
//

import Foundation

/**
 The common wrapper object that is returned by the StackExchange API.
 
 - author: FelixSFD
 
 - seealso: [StackExchange API](https://api.stackexchange.com/docs/wrapper)
 */
public class APIResponse<T: JsonConvertible>: JsonConvertible {
    
    // - MARK: Items
    
    /**
     The items that are returned of the generic type `T`.
     
     - note: It's always an array. Even if only a single item was requested.
     
     - author: FelixSFD
     */
    public var items: [T]?
    
    
    // - MARK: Initializers
    
    /**
     Basic initializer without default values
     */
    public init() {
        
    }
    
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
        self.backoff = dictionary["backoff"] as? Int
        self.error_id = dictionary["error_id"] as? Int
        self.error_message = dictionary["error_message"] as? String
        self.error_name = dictionary["error_name"] as? String
        self.has_more = dictionary["has_more"] as? Bool
        
        
        //items
        if let array = dictionary["items"] as? [[String: Any]] {
            var tmpItems = [T]()
            for item in array {
                tmpItems.append(T(dictionary: item))
            }
            
            if tmpItems.count > 0 {
                self.items = tmpItems
            }
        }
        
    }
    
    // - MARK: JsonConvertible
    
    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        
        dict["backoff"] = backoff
        dict["error_id"] = error_id
        dict["error_message"] = error_message
        dict["error_name"] = error_name
        dict["has_more"] = has_more
        dict["page"] = page
        dict["page_size"] = page_size
        dict["quota_max"] = quota_max
        dict["quota_remaining"] = quota_remaining
        dict["total"] = total
        dict["type"] = type
        
        return dict
    }
    
    public var jsonString: String? {
        return (try? JsonHelper.jsonString(from: self)) ?? nil
    }
    
    
    // - MARK: Fields
    
    public var backoff: Int?
    
    public var error_id: Int?
    
    public var error_message: String?
    
    public var error_name: String?
    
    public var has_more: Bool?
    
    public var page: Int?
    
    public var page_size: Int?
    
    public var quota_max: Int?
    
    public var quota_remaining: Int?
    
    public var total: Int?
    
    public var type: String?
    
}
