//
//  JsonConvertible.swift
//  SwiftStack
//
//  Created by FelixSFD on 06.12.16.
//
//

import Foundation

/**
 Objects that can be created fom a JSON-string or be converted to one, conform to this protocol.
 
 The used datatypes should be in the format as returned from the StackExchange API. (for example `Date` as UNIX timestamp)
 
 - note: This protocol inherits from `DictionaryConvertible`
 
 - author: FelixSFD
 */
public protocol JsonConvertible: DictionaryConvertible {
    /**
     Initializes the object from a JSON-string
     
     The initializer should fail when `JSONSerialization.jsonObject(with:options:)` throws an error.
     
     **Example implementation:**
     
     ```
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
     ```
     
     It's highly recommended to use this example as it is and pass the dictionary decoded from JSON to `init(dictionary:)`!
     
     - parameter json: The JSON-string that is representing the object
     
     - author: FelixSFD
     */
    init?(jsonString json: String)
    
    /**
     Returns the JSON-representation of the object
     */
    var jsonString: String? { get }
}
