//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Mac on 1/30/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell

    }
    
    ///////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.updateModel(at: indexPath)
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            return [deleteAction]
        }
        ////////////////////////////////////////////////////////////////////////
    
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            //   options.transitionStyle = .border
            return options
        }
        
    func updateModel(at indexPath: IndexPath) {
        //Update our data model.
    }
        
        //
        //    //this is a function i made to delete a category
//        func deleteCategory(indexPath: Int)  {
//
//            if let category = categories?[indexPath] {
//                do{
//                    try realm.write{
//                        realm.delete(category)
//                    }
//                }catch{
//                    print("Error deleting category, \(error)")
//                }
//            }
//            // tableView.reloadData()
//        }
}