//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 05/04/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import SwipeCellKit
import  ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
//TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! SwipeTableViewCell
        
        cell.delegate = self
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Delet cell")
            
            self.UpdateModel(at: indexPath)

        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
}
    func UpdateModel(at indexPath: IndexPath){
        
    }
}

