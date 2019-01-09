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
    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = Item()
        item1.titleText = "Vanakkam"
        itemArray.append(item1)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = self.itemArray[indexPath.row].titleText
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done ? (tableView.cellForRow(at: indexPath)?.accessoryType = .none) : (tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonAction(_ sender: Any) {
        var textfield = UITextField()
        let alertNewItem = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let add = UIAlertAction(title: "New Item", style: .default) { (action) in
            let item = Item()
            item.titleText = textfield.text!
            self.itemArray.append(item)
            self.tableView.reloadData()
        }
        alertNewItem.addAction(add)
        alertNewItem.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create the New notes"
            textfield = alertTextfield
        }
       present(alertNewItem, animated: true, completion: nil)
    }
}

