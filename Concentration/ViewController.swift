//
//  ViewController.swift
//  Concentration
//
//  Created by Frank Su on 2018-06-24.
//  Copyright © 2018 CandylineStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //Controller->Model to send stuff to Concentration class
    //lazy var: doesn't actaully initialize until someone uses it
    //can't use game until it is initialized; cannot have didSet{}:cannot use property oberver
    //number of cards in the game is intimately tied to the UI
    private lazy var game =
        Concentration(numberOfPairsOfCards: numberOfPairsOfCards )
    //computed property since value depends on cardButtons.count
    var numberOfPairsOfCards: Int {
        return ((cardButtons.count + 1) / 2)
    }
    // swift requires all properties (instance variables) has to be initialized
    // we allow people to get flipCount but we don't want ppl setting it
    private(set) var flipCount = 0 { //property observers
        didSet { // everytime the variable changes it does this code stuff
            updateFlipCountLabel()
        }
    }
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    //outlet is an instance variable
    //when it is making the connection its 'setting' so you can use didSet
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    //outlet collection is an array of items; cmd + click to rename everywhere
    @IBOutlet private var cardButtons: [UIButton]!
    
    //action is a method. Its a UIButton that sends to the method
    @IBAction private func touchCard(_ sender: UIButton) {
        
        flipCount += 1
        //optionals: set or not set, set and comes with value. Int in this case
        //! assume optional is set, and grab the value. 'if' also unwraps
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } //! assume this optional is set and get the associated value
        else {
            print ("chosen card was not in cardButtons")
        }
    }
    
    //external name withEmoji,on, internal names emoji, button
//    func flipCard(withEmoji emoji: String, on button: UIButton){
//        if button.currentTitle == emoji {
//            button.setTitle("", for: UIControlState.normal)
//            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//        } else {
//            button.setTitle(emoji, for: UIControlState.normal)
//            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        }
//    }
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        
        }
        
    }
//    private var emojiChoices = ["🦇","🎃","👻","😱","😈","🍭","🍬","🍎"]
    private var emojiChoices = "🦇🎃👻😱😈🍭🍬🍎"
    //dictionary
    //instead of [Int:String] and using emoji[card.identifier] we can directly compare cards
    //using [Card:String] emoji[card]. Need to make Card hashable
    private var emoji = [Card:String]()
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            //0 to upper bound not including emojiChoices.count
            //this line is covered by extention
            //let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            //remove the emoji from the array when you pick it
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            //emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else {
//            return "?"
//        }
        //equivalent ^ return the unwrapped value, if nil the return "?"
        return emoji[card] ?? "?"
    }
}

//extension extends functionality
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

