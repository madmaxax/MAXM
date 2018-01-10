//
//  ToDoTableViewController.swift
//  MAXM
//
//  Created by Max on 07.01.18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, ToDoCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedCollectionCell: NSIndexPath? {
        didSet {
            //2
            var indexPaths = [IndexPath]()
            if let selectedCollectionCell = selectedCollectionCell {
                indexPaths.append(selectedCollectionCell as IndexPath)
            }
            if let oldValue = oldValue {
                indexPaths.append(oldValue as IndexPath)
            }
            //3
            collectionView?.performBatchUpdates({
                self.collectionView?.reloadItems(at: indexPaths)
            })
        }
    }
    
    var dayArray = [String]()
    var dateArray = [String]()
    
    func getDayText() -> Array<Any> {
        
        if dayArray.count == 8 {
            return dayArray
        } else {
            
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat  = "EE"
            let dayInWeek = dateFormatter.string(from: date as Date)

            switch dayInWeek {
            case "Mon":
                pushDays(day1: "Mon", day2: "Tue", day3: "Wed", day4: "Thu", day5: "Fri", day6: "Sat", day7: "Sun")
                break
            case "Tue":
                pushDays(day1: "Tue", day2: "Wed", day3: "Thu", day4: "Fri", day5: "Sat", day6: "Sun", day7: "Mon")
                break
            case "Wed":
                pushDays(day1: "Wed", day2: "Thu", day3: "Fri", day4: "Sat", day5: "Sun", day6: "Mon", day7: "Tue")
                break
            case "Thu":
                pushDays(day1: "Thu", day2: "Fri", day3: "Sat", day4: "Sun", day5: "Mon", day6: "Tue", day7: "Wed")
                break
            case "Fri":
                pushDays(day1: "Fri", day2: "Sat", day3: "Sun", day4: "Mon", day5: "Tue", day6: "Wed", day7: "Thu")
                break
            case "Sat":
                pushDays(day1: "Sat", day2: "Sun", day3: "Mon", day4: "Tue", day5: "Wed", day6: "Thu", day7: "Fri")
                break
            case "Sun":
                pushDays(day1: "Sun", day2: "Mon", day3: "Tue", day4: "Wed", day5: "Thu", day6: "Fri", day7: "Sat")
                break
            default:
                pushDays(day1: "Mon", day2: "Tue", day3: "Wed", day4: "Thu", day5: "Fri", day6: "Sat", day7: "Sun")
                break
            }
            
            return dayArray
        }
    }
    
    func pushDays(day1: String, day2: String, day3: String, day4: String, day5: String, day6: String, day7: String) {
        dayArray.append(day1)
        dayArray.append(day2)
        dayArray.append(day3)
        dayArray.append(day4)
        dayArray.append(day5)
        dayArray.append(day6)
        dayArray.append(day7)
        dayArray.append(day1)
    }
    
    func getDayDate() -> Array<Any> {
        
        if dateArray.count == 8 {
            return dateArray
        } else {
            
            let date = Date()
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            var day = calendar.component(.day, from: date)
            
            for i in 0 ..< 8 {
                
                switch month {
                case 1, 3, 5, 7, 8, 10, 12:
                    day += 1
                    break
                case 4, 6, 9, 11:
                    day += 1
                    break
                case 2:
                    day += 1
                    break
                default:
                    day += 2
                }
                let dayString = "\(day). \(month)."
                dateArray.append(dayString)
                
            }
            return dateArray
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDayText().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        
        cell.dayText.text = getDayText()[indexPath.row] as? String
        cell.dayDate.text = getDayDate()[indexPath.row] as? String
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
        
    }

    var todoItems:[TodoItem]!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
    }
    
    func loadData() {
        todoItems = [TodoItem]()
        todoItems = DataManager.loadAll(TodoItem.self)
        tableView.reloadData()
    }
    
    @IBAction func addTodo(_ sender: Any) {
        let addAlert = UIAlertController(title: "New Todo Item", message: "Enter a title", preferredStyle: .alert)
        
        addAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Todo Item Title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler:
            { (action:UIAlertAction) in
                
            guard let title = addAlert.textFields?.first?.text else { return }
            let newTodo = TodoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID())
            
            newTodo.saveItem()
                
            self.todoItems.append(newTodo)
                
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
                
            self.tableView.insertRows(at: [indexPath], with: .automatic)
                
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addAlert, animated: true, completion: nil)
    }
    
    func didRequestDelete(_ cell: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            todoItems[indexPath.row].deleteItem()
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didRequestToggle(_ cell: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            var todoItem = todoItems[indexPath.row]
            if todoItem.completed {
                todoItem.markAsIncompleted()
            } else {
                todoItem.markAsCompleted()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell
        cell.delegate = self
        
        let todoItem = todoItems[indexPath.row]
        
        cell.todoLabel.text = todoItem.title
        
        if todoItem.completed {
            cell.todoCheckbox.on = true
        } else {
            cell.todoCheckbox.on = false
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            todoItems[indexPath.row].deleteItem()
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
