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
    
    @IBOutlet var frontTextView: UITextView!
    @IBOutlet var backTextView: UITextView!
    
    // Show contents
    override func viewDidLoad() {
        super.viewDidLoad()
        frontTextView.text = card.frontContents
        backTextView.text = card.backContents
    }
    
    // Save contents when user exit the card
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        // Update contents of the card
        card.frontContents = frontTextView.text
        card.backContents = backTextView.text
        // Save data
        CardManager.main.save(card: card)
    }
    
}
