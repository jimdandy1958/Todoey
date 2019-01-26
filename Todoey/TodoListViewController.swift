//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 1/26/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if a plist exists with previous added items then get it instead of the itemArray default
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
   //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    //MARK -Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //checkmark if there is none.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
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

        //make the add item button to add the item to the listArray
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            //what will happen once the user clicks the add item button on our ui alert
        }

        
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
}

