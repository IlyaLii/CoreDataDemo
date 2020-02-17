//
//  TableViewController.swift
//  CoreDataDemo
//
//  Created by Li on 2/18/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var toDoItems = [Task]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            toDoItems = try context.fetch(fetchRequest)
            print("Fetch!")
        } catch {
            print("Error! \(error), \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Function
    
    func saveToDo(item: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let taskObject = NSManagedObject(entity: entity, insertInto: context) as? Task else { return }
        taskObject.taskToDo = item
        
        do {
            try context.save()
            toDoItems.append(taskObject)
            print("Saved!")
        } catch {
            print("Error! \(error), \(error.localizedDescription)")
        }
    }
    
    //MARK: - @IBAction
    @IBAction func AddTusk(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let addAction = UIAlertAction(title: "Ok", style: .default) { [weak self, weak alert] _ in
            if let text = alert?.textFields?.first?.text {
                self?.saveToDo(item: text)
                self?.tableView.reloadData()
            }
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = toDoItems[indexPath.row]
        
        cell.textLabel?.text = item.taskToDo
        
        return cell
    }
}
