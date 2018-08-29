//
//  Card.swift
//  Concentration
//
//  Created by Frank Su on 2018-08-19.
//  Copyright © 2018 CandylineStudio. All rights reserved.
//  Part of Model

import Foundation

//struct vs class
//struct: no inheritance
//struct: value types; class: reference type
//pass by value: copy on write semantics.
//pass by ref: the thing lives in the heap and have pointers to it.
struct Card: Hashable {
    var hashValue: Int {return identifier}
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    //you can't send it to a Card. The type Card understands.
    //utility function tied to the type.
    private static func getUniqueIdentifier() -> Int {
        //don't need Card.identifierFactory since both var and func are static
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
