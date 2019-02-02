//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Mac on 1/30/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import SwipeCellKit
//                             SWIPE TABLE VIEW CONTROLLER CLASS BEGINNING
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
/////////////////////////////////////////////////////////////////////////////
       //                TableView Datasource Methods
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell

    }
    
///////////////////////////////////////////////////////////////////////////
    //                             SWIPING DELETING
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil}
    
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {
            action, indexPath in
                self.updateModel(at: indexPath)
        }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            return [deleteAction]
        }
    
    //                      TABLEVIEW EDIT ACTIONS OPTIONS FOR ROW AT
    //////////////////////////////////////////////////////////////////////
    //               SWIPE ACTION OPTION: DESTRUCTIVE
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //   options.transitionStyle = .border
        return options
    }
    
    //          UPDATE MODEL
    //////////////////////////////////////////////////////////////////////
    //  CALLED FROM SUB CLASSES TO GET THE INDEX PATH FROM THE SUPER CLASS
    func updateModel(at indexPath: IndexPath) {
        //Update our data model.
    }
}
//                SWIPE TABLE VIEW CONTROLLER CLASS ENDING
