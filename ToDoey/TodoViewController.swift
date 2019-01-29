//
//  TodoViewController.swift
//  ToDoey
//
//  Created by Swetha on 07/01/19.
//  Copyright © 2019 Swetha. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) //.first?.appendingPathComponent("Item.plist") //Creating the file in the mentioned path and add the compount
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataPath)
        searchBar.delegate = self
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        loadItem(with: request)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = self.itemArray[indexPath.row].title
        let item = self.itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done ? (tableView.cellForRow(at: indexPath)?.accessoryType = .none) : (tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonAction(_ sender: Any) {
        var textfield = UITextField()
        let alertNewItem = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let add = UIAlertAction(title: "New Item", style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = textfield.text!
            item.done = false
            self.itemArray.append(item)
            self.saveItem()
        }
        alertNewItem.addAction(add)
        alertNewItem.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create the New notes"
            textfield = alertTextfield
        }
       present(alertNewItem, animated: true, completion: nil)
    }
    func saveItem()  {
        do{
          try context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error for fetching data: \(error)")
        }
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

