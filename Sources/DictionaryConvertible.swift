//
//  DictionaryConvertible.swift
//  SwiftStack
//
//  Created by FelixSFD on 06.12.16.
//
//

import Foundation

/**
 Objects that can be created fom a dictionary or be converted to one, conform to this protocol.
 
 - author: FelixSFD
 */
public protocol DictionaryConvertible {
    /**
     Initializes the object from a dictionary
     
     This initializer should not fail. Since all fields are optionals, it should be possible, that none of the fields will be set.
     
     When implementing this initializer in a subclass that conforms to `DictionaryConvertible`, you should only set the fields that are new in the subclass. The rest sould be initializes with `super.init(dictionary: dictionary)` at the beginning of this initializer.
     
     - parameter dictionary: The dictionary that represents the object.
     
     - author: FelixSFD
     */
    init(dictionary: [String: Any])
    
    /**
     Returns the dictionary-representation of the object
     */
    var dictionary: [String: Any] { get }
}
