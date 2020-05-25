//
//  DoToListTableViewController.swift
//  ToDo_APP
//
//  Created by Kamil Gucik on 20/05/2020.
//  Copyright © 2020 Kamil Gucik. All rights reserved.
//

import Foundation
import UIKit

class ToDoListTableViewController: UITableViewController, NewTaskDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let taskListData = UserDefaults.standard.value(forKey: "savedTasks") as? Data else {
            return
        }
        guard let tasks = try? PropertyListDecoder().decode([NewTask].self, from: taskListData) else {
            return
        }

        self.taskList = tasks

    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddingViewController" {
            let destination = segue.destination as? AddingViewController
            destination?.newTaskDelegate = self
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: nil, action: nil)
        }
    }
    
   private var taskList = [NewTask]()
    
    
    
    private func sortByDate() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeStyle = .none
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "pl")
        
        let sortedArray = self.taskList.sorted {formatter.date(from: $0.data)! < formatter.date(from: $1.data)!}
        self.taskList = sortedArray
        

    }
    
    
    
    func createNewTask(with newTask: NewTask) {
        self.taskList.append(newTask)
        self.sortByDate()
        UserDefaults.standard.set(try? PropertyListEncoder().encode(taskList), forKey: "savedTasks")
        tableView.reloadData()
    }
    
    //MARK:- TableView
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            taskList.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(taskList), forKey: "savedTasks")
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if taskList.count == 0 {
            
            tableView.setEmptyView(title: "Nie masz żadnych zadań.", message: "Twoje zadania pojawią się tutaj po ich dodaniu.")
            
        } else {
            
            tableView.restore()
        }
        return taskList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ToDoListCell else {
            fatalError("Couldnt find cell")
        }
        
        cell.categoryLabel.text = taskList[indexPath.row].category
        cell.contentLabel.text = taskList[indexPath.row].content
        cell.dataLabel.text = taskList[indexPath.row].data
        
        
        let currentDate = Date()
        
        let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.dateFormat = "dd.MM.yyyy"
                formatter.timeStyle = .none
                formatter.timeZone = .current
                formatter.locale = Locale(identifier: "pl")
        
        
        let formatedCurrentDate = formatter.string(from: currentDate)
        let pickedDate = taskList[indexPath.row].data
        
        
        if formatedCurrentDate == pickedDate {
            cell.backgroundColor = UIColor.systemBlue
        }
        
        if formatter.date(from: formatedCurrentDate)! > formatter.date(from: pickedDate)! {
            cell.backgroundColor = UIColor.systemRed
        }
         
        return cell
        }
}

