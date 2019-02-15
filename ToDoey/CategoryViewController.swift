//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Swetha on 28/01/19.
//  Copyright © 2019 Swetha. All rights reserved.
//
import UIKit
import CoreData

class CategoryViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var categoryName = [CategoryItem]()
     let request : NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()
    let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
       
        loadItem()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        cell.textLabel?.text = categoryName[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemList"{
            let destinationVC = segue.destination as! TodoViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoryName[indexPath.row]
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryName.count
    }
    @IBAction func addCategoryAction(_ sender: Any) {
        var textfield = UITextField()
        let alertController = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add new category", style: .default) { (action) in
            let item = CategoryItem(context: self.context)
            item.name = textfield.text
            self.categoryName.append(item)
            self.saveItem()
        }
        alertController.addAction(alertAction)
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textfield = alertTextField
        }
        self.present(alertController, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //MARK:- Load and save the data to coreData context
    func loadItem(request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()){
        do{
            categoryName = try context.fetch(request)
            self.tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    func saveItem(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
}
