//
//  CardViewController.swift
//  flashCards
//
//  Created by 游舒含 on 12/6/20.
//  Copyright © 2020 ShuHan Yu. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    var card: Card!
    var rowIndex: Int = -1
    var isFront: Bool = true
    
    let allCards = CardManager.main.getAllCards()
    let frontBgColor = UIColor.init(red: 80/255, green: 190/255, blue: 80/255, alpha: 1)
    let backBgColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    
    @IBOutlet var cardTextView: UITextView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    // Show contents
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("row index = \(rowIndex)")
        print("cards count = \(allCards.count)")
        // Default settings
        cardTextView.backgroundColor = frontBgColor
        cardTextView.text = card.frontContents
        btnEnabilityControl()
    }
    
    @IBAction func toPrevious(_ sender: UIButton) {
        rowIndex -= 1
        showCurrentCardAtIndex(index: rowIndex)
    }
    
    @IBAction func toNext(_ sender: UIButton) {
        rowIndex += 1
        showCurrentCardAtIndex(index: rowIndex)
    }
    
    @IBAction func flip(_ sender: UIButton) {
        if isFront {
            turnToBackSide()
            isFront = false
        }
        else
        {
            turnToFrontSide()
            isFront = true
        }
    }
    
    func btnEnabilityControl() {
        if allCards.count > 1 {
            // Control accessibility of previous button
            if rowIndex != 0 {
                previousBtn.isEnabled = true
            }
            else {
                previousBtn.isEnabled = false
            }
            
            // Control accessibility of next button
            if rowIndex != allCards.count - 1 {
                nextBtn.isEnabled = true
            }
            else
            {
                nextBtn.isEnabled = false
            }
        }
    }
    
    func showCurrentCardAtIndex(index: Int) {
        card = allCards[rowIndex]
        btnEnabilityControl()
        turnToFrontSide()
    }
    
    func turnToFrontSide() {
        cardTextView.backgroundColor = frontBgColor
        cardTextView.text = card.frontContents
    }
    
    func turnToBackSide() {
        cardTextView.backgroundColor = backBgColor
        cardTextView.text = card.backContents
    }
}
