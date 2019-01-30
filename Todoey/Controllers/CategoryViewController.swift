//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac on 1/28/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods

    //DID SELECT A ROW happens when you click on a row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //PERFORM SEGUE
        performSegue(withIdentifier: "goToItems", sender: self)
        print("performing segue")
    }
    
    //PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
            do {
                try realm.write {
                    realm.add(category)
                }
            } catch {
                print("error saving category \(error)")
            }
            self.tableView.reloadData()
        }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

//
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create an alert controller
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        //create an action within the alert box. the Add item button
        
        //make a textfield() method variable to pass the text out of the addTextField function
        var textField = UITextField()
        
        //put a text field in the alert for the user to type in their addition to the list.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            //set up the global variable to copy what is going to be typed later.
            textField=alertTextField
        }
        
        //make the add item button in the alert winddow to add the item to the categoryArray
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //RealmSwift way
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //RealmSwift function call where we pass the category.
            self.save(category: newCategory)
            
            self.scrollToBottom()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    //scrolls to last item in list
    func scrollToBottom () {
        //this is nil coalescing operator
        let catcount = categories?.count ?? 1
        if catcount - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: catcount - 1, section: 0), at: .bottom, animated: false)
        }
    }


}
