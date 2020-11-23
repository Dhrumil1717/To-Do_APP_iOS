//
//  ViewController.swift
//  File Name :Assignment4
//  Created by Dhrumil Malaviya on 2020-11-11.
//  Student id : 301058391
//  App Description : Creating a UI for TO-DO list application using table view.
//  Version 1.0
//  Copyright © 2020 Dhrumil Malaviya. All rights reserved.



import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTask{
    
    // MARK: - Variables
    var tasks : [Task] = []  //creating an array to add tasks
    var index:Int=0// setting a tag in this file
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tasks.append(Task(name: "Buy Grocery", date: "", description: "",checked: false, dueDate: true, index: 0))
        self.tableView.rowHeight = 69.0
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - Click events
    @objc func editButtonClicked(_ sender: UIButton)
    {
        performSegue(withIdentifier: "segueAddTask", sender: (task: Task(name: tasks[sender.tag].name,
                                                                         date: tasks[sender.tag].date,
                                                                         description: tasks[sender.tag].description,
                                                                         checked: tasks[sender.tag].checked,
                                                                         dueDate: tasks[sender.tag].dueDate,
                                                                         index: sender.tag
        ), taskAction: TaskAction.Edit))
        
        
        
    }
    
    // MARK: - TableView delegate methods
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
            cell.taskCompleteSwitch.isOn = true
        }
        else
        {
            cell.taskCompleteSwitch.isOn=false
        }
        
        return cell
    }
    
    //MARK: - PROTOCOL delegate methods
    func addTask(name: String, date: String, description:String, checked: Bool, dueDate:Bool, index :Int )
    {
        tasks.append(Task(name: name, date: date, description: description, checked: checked,dueDate: dueDate, index: index ))
        tableView.reloadData()
    }
    
    func deleteTask(index: Int)
    {
        tasks.remove(at: index)
        tableView.reloadData()
    }
    
    func editTask(task: Task)
    {
        tasks[task.index] = task
        tableView.reloadData()
    }
    
//MARK:- NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)       //navigate to another screen 
    {
        if segue.identifier == "segueAddTask" {
            let destination = segue.destination as! AddTaskViewController
            
            //passing the data to "AddTaskViewController" once user enters it
            
            if let data = sender as? (task: Task, taskAction: TaskAction)
            {    //using tuples to pass data from class and enum
                
                destination.name = data.task.name
                destination.currentDate = data.task.date
                destination.desc = data.task.description
                destination.fetchIsComplete=data.task.checked
                destination.fetchDueDate=data.task.dueDate
                destination.index=data.task.index
                
                destination.taskAction = data.taskAction
                
            }
              
            destination.delegate=self
        }
    }
}
