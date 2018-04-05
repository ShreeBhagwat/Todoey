//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 01/04/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
   
let realm = try! Realm()
     var categories : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
        //MARK:- TableView DataSource Method.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ??  1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
      cell.textLabel?.text = categories?[indexPath.row].name ?? "Categories Not Added Yet"
        
        
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
    
        
        
        //MARK:- Button Pressed Method.
 
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Category", style: .default) { (action) in
         //What will happen when button is pressed
      
        let newCategory = Category()
        newCategory.name = textFiled.text!
        
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
