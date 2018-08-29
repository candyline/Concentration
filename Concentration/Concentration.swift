//
//  Concentration.swift
//  Concentration
//
//  Created by Frank Su on 2018-08-19.
//  Copyright © 2018 CandylineStudio. All rights reserved.
//  Part of Model 

import Foundation

//class gets a free init when all 'var' are initialized
struct Concentration
{
    //when creating a class think about the public APIs
    //API: list of all the method and instance variables in that class
    
    //init() that creats an empty array
    //you can look at cards, but I'm responsible for setting cards face up down
    private(set) var cards = [Card]()
    
    //what happens when there are 2 cards face up ? or theres none? Optional
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            //use colsure and apply filter function. Puts in array if it returns true
            //oneAndOnly is an extention of a protocol 
            return cards.indices.filter{ cards[$0].isFaceUp}.oneAndOnly
            //return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
//            var foundIndex: Int?
//            //look at all the cards and see if you find only one that's face up
//            //if so, return it, else return nil
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        //if there are more than one card thats face up then
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            // turn all the cards face down except the card at index newValue
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue) //if new value == indexOfOneAndOnlyFaceUpCard
            }
            
        }
    }
    //its because struct is 'copy on write' and does not live one the heap
    //so we need to tell 'func' if it mutates or not then it will copy the bits and pass by value
    mutating func chooseCard(at index: Int) {
        //asserts that this statement is true. if not, then crash and debugger bring to here
        assert(cards.indices.contains(index), "Concentration.chooCard(at: \(index)): chosen index not in the cards")
        //model is going to flip the card over
//        if cards[index].isFaceUp {
//            cards[index].isFaceUp = false
//        } else {
//            cards[index].isFaceUp = true
//        }
        if !cards[index].isMatched {
            // no cards are face up, 2 cards are face up, 1 card faceup match?
            // can't pick the same card and expect it to match
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // since we implemented hashable we don't need to .identifier == .identifier anymore
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                //indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                //turn all the cards face down
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        //countable range 0..<range
        //we don't care what identifier to use so just use _
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
            //cards.append(card)
            cards += [card, card]
        }
        // TODO: Shuffle the cards
    }
}
//extension of a protocol
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
