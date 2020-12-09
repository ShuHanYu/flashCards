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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { (deleteAction, sourceView, completionHandler) in
            if CardManager.main.delete(card: self.cards[indexPath.row]) {
                self.reload()
                completionHandler(true)
            }
            else
            {
                completionHandler(false)
            }
        }
        let editContextualAction = UIContextualAction(style: .normal, title: "Edit") { (editAction, sourceView, completionHandler) in
            self.performSegue(withIdentifier: "editSegue", sender: indexPath)
        }
        
        let actionConfigurations = UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction])
        return actionConfigurations
    }
    
    func reload() {
        cards = CardManager.main.getAllCards()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSegue" {
            if let destination = segue.destination as? CardViewController {
                destination.card = cards[tableView.indexPathForSelectedRow!.row]
                destination.rowIndex = tableView.indexPathForSelectedRow!.row
            }
        }
        else if segue.identifier == "editSegue" {
            print("editSegue")
            print("\(String(describing: sender))")
            if let indexPath = sender as? IndexPath {
                if let destination = segue.destination as? EditCardViewController {
                    destination.rowIndex = indexPath[1]
                    let backItem = UIBarButtonItem()
                    backItem.title = "Cancel"
                    navigationItem.backBarButtonItem = backItem
                }
            }
        }
    }
}

