//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 1/26/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //make an array of objects
    var itemArray = [Item]()
    
    //let defaults = UserDefaults.standard
    
    //make a data path to our stored data for this app
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK - Tableview Datasource Methods

    //NUMBER OF ROWS IN SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //CELL FOR ROW AT INDEX
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary operator that toggles the check mark on and off
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK -Tableview Delegate Methods
    
    //DID SELECT A ROW
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //toggles checkmark status on and off.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //update our files to show the new checkmark status
        saveItems()
        
        //make the row color fade after selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    //ADD BUTTON PRESSED
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create an alert controller
        let alert = UIAlertController(title: "Add New Todoey Item", message: " ", preferredStyle: .alert)
        //create an action within the alert box. the Add item button
        
        //make a textfield() method variable to pass the text out of the addTextField function
        var textField = UITextField()
        
        //put a text field in the alert for the user to type in their addition to the list.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            //set up the global variable to copy what is going to be typed later.
            textField=alertTextField
        }
        
        //make the add item button in the alert winddow to add the item to the listArray
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //instanciate an object
            let newItem = Item()
            
            //set the title property of the object
            newItem.title = "\(self.itemArray.count+1). " + textField.text!
            
            //add the object to the array of objects.. (list)
            self.itemArray.append(newItem)
            
            //update our property list in our plist file
            self.saveItems()
            self.scrollToBottom()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    
    
    //MARK - Model Manipulation Methods
    //ENCODE our list for the plist and send them.
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error endcoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    //get items from the plist and DECODE them
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    //scrolls to last item in list
    func scrollToBottom () {
        if itemArray.count - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: itemArray.count - 1, section: 0), at: .bottom, animated: false)
        }
    }

}
