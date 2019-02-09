//
//  ViewController.swift
//  Todoey
//
//  Created by Mac on 1/26/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//
import UIKit
import RealmSwift
import ChameleonFramework

class StudentProgressViewController: SwipeTableViewController {
    
    //make an array of objects
    let realm = try! Realm()
    
    // this declares a variable called of the results type
    //but does not populate it. that happens in loaditems
    //called when the selected student is sent from vc during segue
    var studentNotes: Results<Item>?
    var TotalItems:   Results<Item>?
//
    var selectedRow = 73
    var row: Int?{
        didSet{
            selectedRow = row!
            print("row selected sent to progress is \(row!)")
        }
    }
//
    var selectedStudent : PublisherName? {
        didSet{
            loadItems()
        }
    }
    //MARK - Tableview Datasource Methods
    

    func loadItems() {
        studentNotes = realm.objects(Item.self).filter("name CONTAINS[cd] %@",selectedStudent?.name)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (studentNotes?.count)!
    }

    //     VIEW DID LOAD      //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //   VIEW WILL APPEAR     //
    override func viewWillAppear(_ animated: Bool) {
        //MAKE THE TITLE OF THE TODO LIST THE SAME AS THE CATEGORY NAME
        title = (selectedStudent?.name)! + " Notes"
        
        //MAKE SURE A CATEGORY IS SELECTED OR CRASH
        guard let colourHex = selectedStudent?.colour else {fatalError()}
    
        updateNavBar(withHexCode: colourHex)
    }
    
    //CHANGE THE NAVBAR OF THE CATEGORY BACK TO IT'S ORIGINAL WHEN MAKING TODO LIST DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "7B34A2")
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
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
    }
    

    //CELL FOR ROW AT INDEX fills in the text of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = studentNotes?[indexPath.row] {
 
            cell.textLabel!.text = item.title

         //   cell.accessoryType = item.done ? .checkmark : .none
 
            if let colour = UIColor(hexString: selectedStudent!.colour)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(studentNotes!.count)) {
                cell .backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        } else {//if no items
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //DID SELECT A ROW Happens when you click on a row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoStudentNote", sender: self)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! StudentNoteViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedStudentNote = studentNotes?[indexPath.row]
          //studentNotes?.name[indexPath.row]  destinationVC.row = self.selectedStudent?.items.row//Item.row
          //  print("sending the name of ", studentNotes?.name[indexPath.row])
        }/////////////////////////////////////////////////
        //////////////////////////////////////////////////

    }
    
    //ADD BUTTON PRESSED
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component( .month, from: date)
        let day   = calendar.component( .day,   from: date)
        let year  = calendar.component( .year,  from: date)
        
        let alert = UIAlertController(title: "Add new note for \(self.selectedStudent!.name)", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Date", style: .default) { (action) in
            if textField.text == ""{ textField.text = "\(month) / \(day) / \(year)"}
                if let currentStudent = self.selectedStudent {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            newItem.studentNote = "\(currentStudent.name) note"
                            newItem.name = "\(currentStudent.name)"
                            currentStudent.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new item, \(error)")
                    }
                }
                self.tableView.reloadData()
                self.scrollToBottom()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField=alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = studentNotes?[indexPath.row] {
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
        let itemcount = studentNotes?.count ?? 1
        if itemcount - 1 > 0 {
            tableView.scrollToRow(at: IndexPath(row: itemcount - 1, section: 0), at: .bottom, animated: false)
        }
    }

}

//SET THE BACKGROUND OF THE SEARCH BAR TO THE SAME COLOR
//searchBar.barTintColor = navBarColour

//    //MADE A LINK SO THAT WE CAN CHANGE SEARCH BAR BACKGROUND COLOR
//    @IBOutlet weak var searchBar: UISearchBar!


//extension StudentProgressViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        studentNotes = studentNotes?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title",ascending: true)
//        tableView.reloadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            tableView.reloadData()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}

