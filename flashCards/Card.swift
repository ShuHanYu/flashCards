//
//  Card.swift
//  flashCards
//
//  Created by 游舒含 on 12/6/20.
//  Copyright © 2020 ShuHan Yu. All rights reserved.
//

import Foundation
import SQLite3

struct Card {
    let id: Int
    var frontContents: String
    var backContents: String
}

class CardManager {
    // Connecting database
    // Create a var pointer of database if it is not exist
    var database: OpaquePointer!
    
    // Create a cardManager singleton
    static let main = CardManager()
    // Avoid others accidentally init a cardManager object
    private init() {
    }
    
    // Get database URL from fileManager
    func connect() {
        if database != nil {
            return
        }
        
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("cards.sqlite3")
            // Open DB
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("Could not open database")
                return
            }
            // Create table if not exists
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS cards (frontContents TEXT, backContents TEXT)", nil, nil, nil) != SQLITE_OK {
                print("could not create table")
                return
            }
        }
        catch _ {
            print("could not create database URL")
        }
    }
    
    // Creating cards
    func create(card: Card) {
        connect()
        
        // Prepare query: create a statement for sqlite to execute
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "INSERT into cards (frontContents, backContents) VALUES (?, ?)", -1, &statement, nil) != SQLITE_OK {
            print("could not create insert query")
        }
        
        // Bind data to query
        sqlite3_bind_text(statement, 1, NSString(string: card.frontContents).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, NSString(string: card.backContents).utf8String, -1, nil)
        
        // Execute query
        if sqlite3_step(statement) != SQLITE_DONE {
            print("could not insert card")
        }
        // Finalize query
        sqlite3_finalize(statement)
    }
    
    // Getting last rowid
    func getLastRowId() -> Int {
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    // Getting cards
    func getAllCards() -> [Card] {
        connect()
        var result: [Card] = []
        
        // Prepare query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "SELECT rowid, frontContents, backContents FROM cards", -1, &statement, nil) != SQLITE_OK {
            print("could not create select query")
            return []
        }
        // Execute query, turn the result into Card object
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Card(id: Int(sqlite3_column_int(statement, 0)), frontContents: String(cString:sqlite3_column_text(statement, 1)), backContents: String(cString:sqlite3_column_text(statement, 2))))
        }
        // Finalize query
        sqlite3_finalize(statement)
        return result
    }
    
    // Saving cards
    func save(card: Card) {
        connect()
        
        // Prepare query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE cards SET frontContents = ?, backContents = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("could not create update query")
        }
        
        // Bind data to query
        sqlite3_bind_text(statement, 1, NSString(string: card.frontContents).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, NSString(string: card.backContents).utf8String, -1, nil)
        sqlite3_bind_int(statement, 3, Int32(card.id))
        
        // Execute query
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error updating card")
        }
        
        // Finalize statement to clean up
        sqlite3_finalize(statement)
    }
    
    func delete(card: Card) -> Bool {
        connect()
        
        // Prepare query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM cards WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Could not create delete query")
            return false
        }
        
        // Bind data to query
        sqlite3_bind_int(statement, 1, Int32(card.id))
        
        // Execute query
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error deleting card")
            return false
        }
        
        sqlite3_finalize(statement)
        return true
    }
}
