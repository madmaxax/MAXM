//
//  ToDoItem.swift
//  MAXM
//
//  Created by Max on 07.01.18.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

struct TodoItem : Codable {
    
    var title:String
    var description:String
    var completed:Bool
    var createdAt:Date
    var itemIdentifier:UUID
    
    func saveItem() {
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func markAsCompleted() {
        self.completed = true
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    mutating func markAsIncompleted() {
        self.completed = false
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
}
