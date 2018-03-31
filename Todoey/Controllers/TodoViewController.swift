//
//  ViewController.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 29/03/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Buy Milk"
        itemArray.append(newItem3)
      
        
        if  let items = defaults.array(forKey: "TodoListArray") as? [Item]{
        itemArray = items
      
        }
    }

    //MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        print("CellForRow")
       
        let item = itemArray[indexPath.row]
       
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        
        return cell
    }
    
    //MARK:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
     
        
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK:- Add New Button
    
    @IBAction func Add(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
       
            
            let newItem = Item()
            newItem.title = textFiled.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        alert.addTextField { (addTextFiled) in
            addTextFiled.placeholder = "Create New Item"
            textFiled = addTextFiled
            
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

