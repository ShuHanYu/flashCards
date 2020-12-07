//
//  ViewController.swift
//  flashCards
//
//  Created by 游舒含 on 12/6/20.
//  Copyright © 2020 ShuHan Yu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var cards: [Card] = []
    
    @IBAction func createCard() {
        let _ = CardManager.main.create()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: show folder title as section name
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        cell.textLabel?.text = cards[indexPath.row].frontContents
        return cell
    }
    
    func reload() {
        cards = CardManager.main.getAllCards()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardSegue" {
            if let destination = segue.destination as? CardViewController {
                destination.card = cards[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

