//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 01/04/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
var categories = [Category]()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
        //MARK:- TableView DataSource Method.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
        
    }
        
        
        //MARK:- Data Manuplation Method.
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving Category Items\(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
             categories = try context.fetch(request)
        } catch {
            print("Error Fetching categories\(error)")
        }
        tableView.reloadData()
    }
    
        
        
        //MARK:- Button Pressed Method.
 
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Category", style: .default) { (action) in
         //What will happen when button is pressed
      
        let newCategory = Category(context: self.context)
        newCategory.name = textFiled.text!
        self.categories.append(newCategory)
        self.saveItems()
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
}
