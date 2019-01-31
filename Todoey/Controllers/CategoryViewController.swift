//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac on 1/28/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //addition code not in the super class
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour )else {fatalError()}
            
            cell.backgroundColor = categoryColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    
    //MARK: - LOAD CATEGORIES
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //MARK: = DELETE DATA FROM SWIPE
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create an alert controller
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)

        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            //set up the global variable to copy what is going to be typed later.
            textField=alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            if newCategory.name != ""{
            self.save(category: newCategory)
            }
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
