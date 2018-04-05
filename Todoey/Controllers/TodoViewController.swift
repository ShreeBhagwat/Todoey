//
//  ViewController.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 29/03/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: UITableViewController {

    
   var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
          loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        loadItems()
    }

    //MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
//        print("CellForRow")
       
        if let item = todoItems?[indexPath.row] {
       
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
                }
            } catch {
                    print("Error Updating data \(error)")
                }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK:- Add New Button
    
    @IBAction func Add(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
       
            
          if  let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let newItem = Item()
                    
//                    if newItem.title != nil {
                    newItem.title = textFiled.text!
//                    } else {
//                        newItem.title = "New Item"
//                    }
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new items \(error)")
            }
          
            }
             self.tableView.reloadData()
        }
            
        alert.addTextField { (addTextFiled) in
            addTextFiled.placeholder = "Create New Item"
            textFiled = addTextFiled
            
        }
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK=:- Data Manuplation
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
}
}

    //MARK:- Search Bar Methods

    extension TodoViewController : UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
            tableView.reloadData()
        }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadItems()
            
            DispatchQueue.main.async {
             searchBar.resignFirstResponder()
            }
            
        }
    }

}



