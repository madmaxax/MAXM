//
//  SettingsViewController.swift
//  MAXM
//
//  Created by Max on 10.01.18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var todoItems:[TodoItem]!
    
    var repeatArray = ["Mo"]
    
    @IBOutlet var repeatView: UITableView!
    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDescription: UITextView!
    @IBOutlet weak var myDate: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
                print("You selected cell number: \(indexPath.row)!")
                print(repeatArray)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeatLabel?.text = "\(repeatArray)"
        
        var components = DateComponents()
        components.day = 0
        components.month = 0
        components.year = 0
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.day = 10
        components.month = 0
        components.year = 0
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        myDate.minimumDate = minDate
        myDate.maximumDate = maxDate
        
    }
    
        
    @IBAction func saveItem(_ sender: Any) {
        guard let title = myTitle?.text else { return }
        guard let description = myDescription?.text else { return }
        print(title)
        print(description)
        let newTodo = TodoItem(title: title, description: description, completed: false, createdAt: Date(), itemIdentifier: UUID())
        
        newTodo.saveItem()

        self.todoItems?.append(newTodo)

        let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)

        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
