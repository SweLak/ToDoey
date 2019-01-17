//
//  TodoViewController.swift
//  ToDoey
//
//  Created by Swetha on 07/01/19.
//  Copyright © 2019 Swetha. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    var itemArray = [Item]()
    var dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist") //Creating the file in the mentioned path and add the compount
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = self.itemArray[indexPath.row].titleText
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
            let item = Item()
            item.titleText = textfield.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataPath!)
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    func loadItem(){
        let decoder = PropertyListDecoder()
        do{
            let data = try Data(contentsOf: dataPath!)
            itemArray = try decoder.decode([Item].self, from: data)
            print(itemArray[0].done)
        }catch{
            print(error)
        }
    }
}

