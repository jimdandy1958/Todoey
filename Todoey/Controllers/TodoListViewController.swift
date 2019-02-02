//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 1/26/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

//import CoreData
import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    //make an array of objects
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    //MADE A LINK SO THAT WE CAN CHANGE SEARCH BAR BACKGROUND COLOR
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet{loadItems()}
    }
    
    //     VIEW DID LOAD      //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //   VIEW WILL APPEAR     //
    override func viewWillAppear(_ animated: Bool) {
        //MAKE THE TITLE OF THE TODO LIST THE SAME AS THE CATEGORY NAME
        title = selectedCategory?.name
        
        //MAKE SURE A CATEGORY IS SELECTED OR CRASH
        guard let colourHex = selectedCategory?.colour else {fatalError()}
    
        updateNavBar(withHexCode: colourHex)
    }
    
    //CHANGE THE NAVBAR OF THE CATEGORY BACK TO IT'S ORIGINAL WHEN MAKING TODO LIST DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "942192")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String)   {
    
    //MAKE SURE A NAV BAR EXISTS.. IF NOT CRASH IT TO LET YOU KNOW YOU HAVE A PROBLEM
    guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
    
        //USE GAURD TO SEt THE COLOUR OF NAV BAR IF IT EXISTS.  ELSE... CRASH
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        //MAKE NAVBAR OF TODO LIST SAME COLOUR AS CATEGORY USING THE DATABASE VALUE OF COLOUR
        navBar.barTintColor = navBarColour
        
        //SET COLOR OF NAVBAR BUTTONS <- & + TO CONTRAST NAVBAR BACKGROUND
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        //SET THE TITLE FONT COLOR TO CONTRAST THE BACKGROUND
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        //SET THE BACKGROUND OF THE SEARCH BAR TO THE SAME COLOR
        searchBar.barTintColor = navBarColour
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    //CELL FOR ROW AT INDEX fills in the text of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {
 
            cell.textLabel!.text = "\(indexPath.row+1). " + item.title

            cell.accessoryType = item.done ? .checkmark : .none
 
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell .backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        } else {//if no items
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //DID SELECT A ROW Happens when you click on a row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write{
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    //ADD BUTTON PRESSED
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new item, \(error)")
                    }
                }
                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField=alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
        tableView.reloadData()
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do  {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error))")
            }
        }
    }
    
    //SROLL TO THE BOTTOM
    func scrollToBottom () {
        //this is nil coalescing operator
        let itemcount = todoItems?.count ?? 1
        if itemcount - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: itemcount - 1, section: 0), at: .bottom, animated: false)
        }
    }

}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

