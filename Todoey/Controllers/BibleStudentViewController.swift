//
//  MonthViewController.swift
//  Todoey
//
//  Created by Mac on 1/28/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class BibleStudentViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var students: Results<PublisherName>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudents()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //addition code not in the super class
        if let pub = students?[indexPath.row]{
            
            cell.textLabel?.text = pub.name
            
            guard let pubColour = UIColor(hexString: pub.colour )else {fatalError()}
            
            cell.backgroundColor = pubColour
            
            cell.textLabel?.textColor = ContrastColorOf(pubColour, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! StudentProgressViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedStudent = students?[indexPath.row]
            destinationVC.row = indexPath.row
        }
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - Data Manipulation Methods
    
    func save(student: PublisherName) {
            do {
                try realm.write {
                    realm.add(student)
                }
            } catch {
                print("error saving category \(error)")
            }
            self.tableView.reloadData()
        }
    
    
    //MARK: - LOAD CATEGORIES
    func loadStudents() {
        students = realm.objects(PublisherName.self)
        tableView.reloadData()
    }
    
    
    //MARK: = DELETE DATA FROM SWIPE
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.students?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting student, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create an alert controller
        let alert = UIAlertController(title: "Add New Student", message: " ", preferredStyle: .alert)

        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new student"
            //set up the global variable to copy what is going to be typed later.
            textField=alertTextField
        }
        
        let action = UIAlertAction(title: "Add Student", style: .default) { (action) in
            
            let newStudent = PublisherName()
            newStudent.name = textField.text!
            newStudent.colour = UIColor.randomFlat.hexValue()
            if newStudent.name != ""{
            self.save(student: newStudent)
            }
            self.scrollToBottom()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    //scrolls to last item in list
    func scrollToBottom () {
        //this is nil coalescing operator
        let pubcount = students?.count ?? 1
        if pubcount - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: pubcount - 1, section: 0), at: .bottom, animated: false)
        }
    }


}
