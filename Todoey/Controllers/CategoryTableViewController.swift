//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 01/04/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
   
let realm = try! Realm()
     var categories : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
       tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        loadCategories()
    }
        //MARK:- TableView DataSource Method.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ??  1
    }
    
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
      cell.textLabel?.text = categories?[indexPath.row].name ?? "Categories Not Added Yet"
            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "39A3F7" )
//            cell.textLabel?.textColor = ContrastColorOf(UIColor, returnFlat: true)
        return cell
        
    }
        
        
        //MARK:- Data Manuplation Method.
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Category Items\(error)")
        }
        tableView.reloadData()
    }
   
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
 
    
override func UpdateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                }catch {
                    print("Error Deleting Category \(error)")
                }
//                            tableView.reloadData()
            }
        }

    
        

        //MARK:- Button Pressed Method.
 
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Category", style: .default) { (action) in
         //What will happen when button is pressed
      
        let newCategory = Category()
        newCategory.name = textFiled.text!
        newCategory.color = UIColor.randomFlat.hexValue()
        
        self.save(category: newCategory)
        self.tableView.reloadData()
        }
        alert.addTextField { (addTextFiled) in
            addTextFiled.placeholder = "Create New Category"
            textFiled = addTextFiled
            
        }
       
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
 
    
    //MARK:- TableView Delegate Method.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }



    

}
