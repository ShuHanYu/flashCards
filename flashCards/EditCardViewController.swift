//
//  EditCardViewController.swift
//  flashCards
//
//  Created by 游舒含 on 12/8/20.
//  Copyright © 2020 ShuHan Yu. All rights reserved.
//

import UIKit

class EditCardViewController: UIViewController, UITextViewDelegate {
    var rowIndex: Int!
    var card: Card!
    
    @IBOutlet weak var frontTextView: UITextView!
    @IBOutlet weak var backTextView: UITextView!
    
    let frontBgColor = UIColor.init(red: 80/255, green: 190/255, blue: 80/255, alpha: 1)
    let backBgColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("rowIndex = \(String(describing: rowIndex))")
        
        card = CardManager.main.getAllCards()[rowIndex]
        frontTextView.backgroundColor = frontBgColor
        backTextView.backgroundColor = backBgColor
        frontTextView.text = card.frontContents
        backTextView.text = card.backContents
        
        frontTextView.delegate = self
        backTextView.delegate = self
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        card.frontContents = frontTextView.text
        card.backContents = backTextView.text
        CardManager.main.save(card: card)
        navigationController?.popViewController(animated: true)
    }
    
}
