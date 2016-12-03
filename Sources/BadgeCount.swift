//
//  BadgeCount.swift
//  SwiftStack
//
//  Created by Felix Deil on 03.12.16.
//
//

import Foundation

/**
 Represents the numbers of gold, silver and bronze badges a `User` has.
 
 - author: FelixSFD
 
 - seealso: [StackExchage API](https://api.stackexchange.com/docs/types/badge-count)
 */
public struct BadgeCount {
    public var bronze: Int
    public var silver: Int
    public var gold: Int
    
    // - MARK: Initializers
    
    /**
     Basic initializer with 0 as default values.
     */
    public init() {
        bronze = 0
        silver = 0
        gold = 0
    }
    
    /**
     Initializes the struct with the number of badges.
     */
    public init(gold: Int, silver: Int, bronze: Int) {
        self.bronze = bronze
        self.silver = silver
        self.gold = gold
    }
}
