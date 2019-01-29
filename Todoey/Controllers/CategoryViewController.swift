//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac on 1/28/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    
    //Here we get our AppDelegate class as an object and get it's persitentContainer method's viewContext parameter
    //we save it in a varialbe called context which is the go-between area that stores what get's commited to the db.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name!
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    //MARK: - Data Manipulation Methods
    
    //save what is in our context to the database (persistentContainer)
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
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
            
            //set the name property of the object
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            //add the object to the array of objects.. (list)
            self.categoryArray.append(newCategory)
            self.saveCategories()
            self.scrollToBottom()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    //scrolls to last item in list
    func scrollToBottom () {
        if categoryArray.count - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: categoryArray.count - 1, section: 0), at: .bottom, animated: false)
        }
    }


}
