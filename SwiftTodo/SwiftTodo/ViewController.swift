//
//  ViewController.swift
//  SwiftTodo
//
//  Created by Jacob Pernell on 10/2/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var todoListData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
        
        title = "Todo List"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodoItem))
        self.navigationItem.rightBarButtonItem = addButton
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMode))
        self.navigationItem.leftBarButtonItem = editButton
        
        setEditButtonEnabledStatus()
    }
    
    // MARK: - Tableview setup
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = todoListData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.isEditing == true {
            let todoEditAlert = UIAlertController(title: "Edit Todo", message: nil, preferredStyle: .alert)
            
            todoEditAlert.addTextField { textField in
                textField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
            }
            
            todoEditAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                
                if let newTodo = todoEditAlert.textFields?.first?.text {
                    if newTodo != "" {
                        self.todoListData[indexPath.row] = newTodo
                        print(self.todoListData)
                        self.tableView.reloadData()
                        self.setEditButtonEnabledStatus()
                    } else {
                        let todoIsBlankAlert = UIAlertController(title: "Cannot add blank todo", message: nil, preferredStyle: .alert)
                        todoIsBlankAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(todoIsBlankAlert, animated: true, completion: nil)
                    }
                }
            }))
            
            todoEditAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(todoEditAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Cell swipe actions (delete / confirm)
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            handleCompleteTodo(forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeRight = UIContextualAction(style: .normal,
                                        title: "Complete") { [weak self] (action, view, completionHandler) in
                                            self?.handleCompleteTodo(forRowAt: indexPath)
                                            completionHandler(true)
        }
        swipeRight.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [swipeRight])
    }
    
    func handleCompleteTodo(forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        todoListData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        setEditButtonEnabledStatus()
    }
    
    // MARK: - Add new todo
    @objc func addTodoItem() {
        let todoAlert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        
        todoAlert.addTextField { textField in
            textField.placeholder = "New todo item..."
        }
        
        todoAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            
            if let newTodo = todoAlert.textFields?.first?.text {
                if newTodo != "" {
                    self.todoListData.append(newTodo)
                    self.tableView.reloadData()
                    self.setEditButtonEnabledStatus()
                } else {
                    let todoIsBlankAlert = UIAlertController(title: "Cannot add blank todo", message: nil, preferredStyle: .alert)
                    todoIsBlankAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(todoIsBlankAlert, animated: true, completion: nil)
                }
            }
        }))
        
        todoAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(todoAlert, animated: true, completion: nil)
    }
    
    // MARK: - Edit mode
    @objc func editMode() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    func setEditButtonEnabledStatus() {
        if todoListData.isEmpty {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        if self.isEditing == false {
//            self.editButtonItem.title = "Edit"
//        } else {
//            self.editButtonItem.title = "Done"
//        }
//    }
//
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todoListData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}

