//
//  ViewController.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 29/03/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoViewController: SwipeTableViewController {

    
   var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
          loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        loadItems()
        tableView.separatorStyle = .none
    }
    
        override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else {fatalError()}
        title = selectedCategory?.name
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Bar does not exit")}
        guard let navBarColor = UIColor(hexString: colorHex) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor

        }
    override func viewWillDisappear(_ animated: Bool) {
        guard let orignalColor = UIColor(hexString: "1D9BF6") else {fatalError()}
        navigationController?.navigationBar.barTintColor = orignalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
    }

    //MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let item = todoItems?[indexPath.row] {
       
        cell.textLabel?.text = item.title
         
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        
       
        
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
        tableView.rowHeight = 70.0
}

    
    override func UpdateModel(at indexPath: IndexPath) {
        if let itemsForDeletion = self.todoItems?[indexPath.row] {
            do {
            try self.realm.write {
             self.realm.delete(itemsForDeletion)
        }
            }catch {
                print("Error deletion data\(error)")
            }
}
//        tableView.reloadData()
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





