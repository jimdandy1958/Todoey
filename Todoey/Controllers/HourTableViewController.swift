//
//  HourTableViewController.swift
//  JWMinistry
//
//  Created by Mac on 2/1/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class HourTableViewController: SwipeTableViewController {
    
    //make an array of objects
    var hourlist: Results<Hour>?
    let realm = try! Realm()
    
    var selectedMonth : Month? {
        didSet{
            loadItems()
            
        }
    }
    
    //     VIEW DID LOAD      //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //   VIEW WILL APPEAR     //
    override func viewWillAppear(_ animated: Bool) {
        //MAKE THE TITLE OF THE TODO LIST THE SAME AS THE MONTH NAME
        title = selectedMonth?.monthName
        
        //MAKE SURE A MONTH IS SELECTED OR CRASH
        guard let colourHex = selectedMonth?.colour else {fatalError()}
        
        updateNavBar(withHexCode: colourHex)
    }
    
    //CHANGE THE NAVBAR OF THE MONTH BACK TO IT'S ORIGINAL WHEN MAKING TODO LIST DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "942192")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String)   {
        
        //MAKE SURE A NAV BAR EXISTS.. IF NOT CRASH IT TO LET YOU KNOW YOU HAVE A PROBLEM
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        
        //USE GAURD TO SEt THE COLOUR OF NAV BAR IF IT EXISTS.  ELSE... CRASH
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        //MAKE NAVBAR OF HOUR LIST SAME COLOUR AS MONTH USING THE DATABASE VALUE OF COLOUR
        navBar.barTintColor = navBarColour
        
        //SET COLOR OF NAVBAR BUTTONS <- & + TO CONTRAST NAVBAR BACKGROUND
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        //SET THE TITLE FONT COLOR TO CONTRAST THE BACKGROUND
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourlist?.count ?? 1
    }
    
    //CELL FOR ROW AT INDEX fills in the text of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = hourlist?[indexPath.row] {
            
            cell.textLabel!.text = "\(item.hourValue)"
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedMonth!.colour)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(hourlist!.count)) {
                cell .backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        } else {//if no items
            cell.textLabel?.text = "No Hours Added"
        }
        return cell
    }
    
    //DID SELECT A ROW Happens when you click on a row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //change to done to insert checkmark
        if let item = hourlist?[indexPath.row] {
            do{ try realm.write{ item.done = !item.done }
            }catch{ print("Error saving done status, \(error)")}
        }
        //reload the view to show the check mark change
        tableView.reloadData()
        //deselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //ADD BUTTON PRESSED
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Number of Hours", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Enter Even Number Of Hours", style: .default) { (action) in
            if textField.text != ""{
                if let currentMonth = self.selectedMonth {
                    do{
                        try self.realm.write {
                            let newItem = Hour()
                            newItem.hourValue = Int(textField.text!) ?? 0
                            newItem.dateCreated = Date()
                            currentMonth.hours.append(newItem)
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
            alertTextField.placeholder = "create new hour entry"
            textField=alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
        tableView.reloadData()
    }
    
    func loadItems() {
        hourlist = selectedMonth?.hours.sorted(byKeyPath: "hourValue", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = hourlist?[indexPath.row] {
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
        let itemcount = hourlist?.count ?? 1
        if itemcount - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: itemcount - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
}

