//
//  MonthTableTableViewController.swift
//  JWMinistry
//
//  Created by Mac on 2/1/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class MonthTableTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var months: Results<Month>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMonths()
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView,cellForRowAt: indexPath)
        //code not in super class.
        if let month = months?[indexPath.row]{
            
            cell.textLabel?.text = month.monthName
            
            guard let monthColour = UIColor(hexString: month.colour )else {fatalError()}
            
            cell.backgroundColor = monthColour
            
            cell.textLabel?.textColor = ContrastColorOf(monthColour, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoHours", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HourTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedMonth = months?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(month: Month) {
        do {
            try realm.write {
                realm.add(month)
            }
        } catch {
            print("error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - LOAD MONTHS
    func loadMonths() {
        months = realm.objects(Month.self)
        tableView.reloadData()
    }
    
    
    //MARK: = DELETE DATA FROM SWIPE
    override func updateModel(at indexPath: IndexPath) {
        if let monthForDeletion = self.months?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(monthForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Months
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create an alert controller
        let alert = UIAlertController(title: "Add New Month", message: " ", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new month"
            //set up the global variable to copy what is going to be typed later.
            textField=alertTextField
        }
        
        let action = UIAlertAction(title: "Add Month", style: .default) { (action) in
            
            let newMonth = Month()
            newMonth.monthName = textField.text!
            newMonth.colour = UIColor.randomFlat.hexValue()
            if newMonth.monthName != ""{
                self.save(month: newMonth)
            }
            self.scrollToBottom()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    //scrolls to last item in list
    func scrollToBottom () {
        //this is nil coalescing operator
        let monthcount = months?.count ?? 1
        if monthcount - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: monthcount - 1, section: 0), at: .bottom, animated: false)
        }
    }
}
