//
//  ViewController.swift
//  File Name :Assignment4
//  Created by Dhrumil Malaviya on 2020-11-11.
//  Student id : 301058391
//  App Description : Creating a UI for TO-DO list application using table view.
//  Version 1.0
//  Copyright © 2020 Dhrumil Malaviya. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTask{
    
    
   
    var tasks : [Task] = []  //creating an array to add tasks

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tasks.append(Task(name: "Buy Grocery", date: ""))
        self.tableView.rowHeight = 69.0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  //returns the number of rows that are to be displayed
    {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        //connecting the cell with the taskcell.swift file
        
        cell.taskNameLabel.text = tasks[indexPath.row].name //assigns text to label
        cell.dueDateLabel.text = tasks[indexPath.row].date
        cell.editButton.tag=indexPath.row
        
        cell.editButton.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
        
        
        if tasks[indexPath.row].checked
        {
            cell.taskCompleteSwitch.isOn = false
        }
        else
        {
            cell.taskCompleteSwitch.isOn=true
            
        }
        return cell
    }
     
    @objc func editButtonClicked(_ sender: UIButton)
    {
        performSegue(withIdentifier: "segueAddTask", sender: Task(name: tasks[sender.tag].name,
                                                                  date: tasks[sender.tag].date))
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)       //navigate to another screen
    {
        
        let destination = segue.destination as! AddTaskViewController
        if let data = sender as? Task {
            
        destination.name = data.name
        destination.currentDate = data.date
        }
        
        destination.delegate=self
    }
    func addTask(name: String, date: String)
    {
        tasks.append(Task(name: name, date: date ))
        tableView.reloadData()
    }
  
}

class Task                  //creating a class and adding one parameter to make a call
{
     var name = ""
    var checked = false
    var date = ""
    
    convenience init (name : String, date : String)
    {
    self.init()
    self.name = name
    self.date = date
    
    }
}

