//
//  WriteCardViewController.swift
//  flashCards
//
//  Created by 游舒含 on 12/7/20.
//  Copyright © 2020 ShuHan Yu. All rights reserved.
//

import UIKit

class WriteCardViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var frontEditTextView: UITextView!
    @IBOutlet var backEditTextView: UITextView!
    
    var card = Card(id: CardManager.main.getLastRowId(), frontContents: "", backContents: "")
    let frontBgColor = UIColor.init(red: 80/255, green: 190/255, blue: 80/255, alpha: 1)
    let backBgColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    let frontPlaceholder = "Tap to edit front contents."
    let backPlaceholder = "Tap to edit back contents."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontEditTextView.delegate = self
        backEditTextView.delegate = self
        frontEditTextView.backgroundColor = frontBgColor
        backEditTextView.backgroundColor = backBgColor
        
        // Set placeholder
        frontEditTextView.text = frontPlaceholder
        frontEditTextView.textColor = UIColor.darkGray
        backEditTextView.text = backPlaceholder
        backEditTextView.textColor = UIColor.darkGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        setSaveButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Clear placeholder text view when user begin to edit
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        setSaveButton()
    }
    
    // Place back placeholder if user didn't enter anything
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView .isEqual(frontEditTextView) {
                textView.text = frontPlaceholder
            }
            else {
                textView.text = backPlaceholder
            }
            textView.textColor = UIColor.lightGray
        }
        setSaveButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setSaveButton()
    }
    
    // save button accessibility
    func setSaveButton() {
        if frontEditTextView.text .isEmpty && backEditTextView.text .isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        if frontEditTextView.text == frontPlaceholder && backEditTextView.text == backPlaceholder {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        if (frontEditTextView.text .isEmpty && backEditTextView.text == backPlaceholder) || (frontEditTextView.text == frontPlaceholder && backEditTextView.text .isEmpty) {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    // Save data
    @objc func save() {
        card.frontContents = frontEditTextView.text
        card.backContents = backEditTextView.text
        CardManager.main.create(card: card)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
