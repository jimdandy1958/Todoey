//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 1/26/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import CoreData
import UIKit

class TodoListViewController: UITableViewController {
    
    //make an array of objects
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    //Here we get our AppDelegate class as an object and get it's persitentContainer method's viewContext parameter
    //we save it in a varialbe called context which is the go-between area that stores what get's commited to the db.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //CELL FOR ROW AT INDEX fills in the text of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row+1). " + item.title!
        
        //ternary operator that toggles the check mark on and off
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK -Tableview Delegate Methods
    
    //DID SELECT A ROW Happens when you click on a row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code to update cells if desired
        //itemArray[indexPath.row].setValue(" ...Completed", forKey: "title")
        
        //code to delete items when we click on them. note.. you have to delete them
        //from the context first before you delet them from the item array so that
        //you do not get an index out of range error when the context tries to delete
        //an item the no longer exists.. and of course you have to use saveItem to
        //update the data base
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //toggles checkmark status on and off.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //update our database with the latest changes to the context
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
            
            //set the title property of the object

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            //add the object to the array of objects.. (list)
            self.itemArray.append(newItem)
            self.saveItems()
            self.scrollToBottom()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    
    //save what is in our context to the database (persistentContainer)
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //note that both parameters have default settings so that you can just say loaditems()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //set the predicate to make it only return items in this category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        //make sure a predicate got passed in that made it not case sensitive and what not..
        if let additionalPredicate = predicate {//if we did get a predicate passed in and it is not nil combine them
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {//otherwise the predicat is just the category predicate.
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fecthing data from context \(error)")
        }
        tableView.reloadData()
    }
    
    //scrolls to last item in list
    func scrollToBottom () {
        if itemArray.count - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: itemArray.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate{

    //SEARCH BAR CLICKED
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[CD] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with:request, predicate: predicate)
    }
    
    //WHEN X IS CLICKED IT WILL REFRESH TO ORIGINAL LIST
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            //THIS MAKES THE KEYBOARD GO AWAY AND THE CURSOR LEAVE THE SEARCH BAR
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}
