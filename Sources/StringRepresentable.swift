//
//  StringRepresentable.swift
//  SwiftStack
//
//  Created by FelixSFD on 08.12.16.
//
//

import Foundation

/**
 Objects that can represented as a `String` conform to this protocol.
 
 - note: This is similar to `RawRepresentable`, but is NOT the same.
 
 - author: FelixSFD
 */
public protocol StringRepresentable {
    /**
     The object as `String`
     */
    var rawValue: String { get }
    
    /**
     Initializes the object from it's `rawString`
     
     - note: The initializer could possible fail. However, if you use the `rawValue` for initialization, it shouldn't.
     
     - parameter rawValue: The `rawValue`
     */
    init?(rawValue: String)
}
