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
        tasks.append(Task(name: "Buy Grocery"))
        self.tableView.rowHeight = 69.0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  //returns the number of rows that are to be displayed
    {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].name //assigns text to label
        if tasks[indexPath.row].checked
        {
            cell.taskCompleteSwitch.isOn = false
        }
        else
        {
            cell.taskCompleteSwitch.isOn=false
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)       //navigate to another screen
    {
        let destination = segue.destination as! AddTaskViewController
        destination.delegate=self
    }
    func addTask(name: String)
    {
        tasks.append(Task(name: name))
        tableView.reloadData()
    }
}

class Task                  //creating a class and adding one parameter to make a call
{
     var name = ""
    var checked = false
    
    convenience init (name : String)
    {
    self.init()
    self.name = name
    }
}

