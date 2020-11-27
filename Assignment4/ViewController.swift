//
//  ViewController.swift
//  File Name :Assignment4
//  Created by Dhrumil Malaviya on 2020-11-11.
//  Student id : 301058391
//  App Description : Creating a UI for TO-DO list application using table view.
//  Version 1.0
//  Copyright © 2020 Dhrumil Malaviya. All rights reserved.




import UIKit
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTask{
    
    // MARK: - Variables
    var tasks : [Task] = []                     //creating an array to add tasks
    var index:Int=0                             // setting a tag in this file
    let database = Database.database().reference().child("TaskList")
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.rowHeight = 69.0
        
        //fetch all the values from database and display when the app starts
        database.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0
            {
                self.tasks.removeAll()
                for tasks in snapshot.children.allObjects as! [DataSnapshot]
                {
                    let taskobject = tasks.value as? [String : AnyObject]
                    let taskName = taskobject?["name"]
                    let taskdueDate = taskobject?["due-date"]
                    let taskDescription = taskobject?["description"]
                    let taskChecked = taskobject?["checked"]
                    let taskDueDate = taskobject?["due-date-specified"]
                    let taskIndex = taskobject?["index"]
                    let taskKey = taskobject?["id"]
                    
                    let taskss = Task(name: taskName as! String, date: taskdueDate as! String, description: taskDescription as! String, checked: (taskChecked?.boolValue ?? false), dueDate: (taskDueDate?.boolValue ?? false), index: taskIndex as! Int, key: taskKey as! String)
                    
                    self.tasks.append(taskss)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Click events
    @objc func editButtonClicked(_ sender: UIButton)
    {
        performSegue(withIdentifier: "segueAddTask", sender: (task: Task(name: tasks[sender.tag].name,
                                                                         date: tasks[sender.tag].date,
                                                                         description: tasks[sender.tag].description,
                                                                         checked: tasks[sender.tag].checked,
                                                                         dueDate: tasks[sender.tag].dueDate,
                                                                         index: sender.tag,
                                                                         key: tasks[sender.tag].key
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
        cell.taskCompleteSwitch.isOn = tasks[indexPath.row].checked
        
        if tasks[indexPath.row].checked
        {
            let strikeName: NSMutableAttributedString =  NSMutableAttributedString(string: cell.taskNameLabel.text!)
            strikeName.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikeName.length))
            
            let strikeDate: NSMutableAttributedString =  NSMutableAttributedString(string: cell.dueDateLabel.text!)
            strikeDate.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikeDate.length))
            
            
            cell.taskNameLabel.attributedText = strikeName
            cell.dueDateLabel.attributedText = strikeDate
            cell.taskCompleteSwitch.isOn = true
            cell.taskCompleteSwitch.isEnabled = false
        }
        else
        {
            let strikeNames: NSMutableAttributedString =  NSMutableAttributedString(string: cell.taskNameLabel.text!)
            strikeNames.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, strikeNames.length))
            
            let strikeDates: NSMutableAttributedString =  NSMutableAttributedString(string: cell.dueDateLabel.text!)
            strikeDates.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, strikeDates.length))
            
            cell.taskNameLabel.attributedText = strikeNames//removes strike through
            cell.dueDateLabel.attributedText = strikeDates
            cell.taskCompleteSwitch.isOn=false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.allowsSelection = false
        self.tableView.delegate = self
    }
    
    //MARK: - PROTOCOL delegate methods
    func addTask(name: String, date: String, description:String, checked: Bool, dueDate:Bool, index :Int , key:String)
    {
        let key = database.childByAutoId().key
        let object :[String: Any] =  ["name":name,"due-date":date,"description":description,"checked":checked,"due-date-specified":dueDate,"index":index,"id":key!]
        database.child(key!).setValue(object)
        
        
    }
    func deleteTask(key:String)
    {
        database.child(key).setValue(nil)
    }
    
    func editTask2(name: String, date: String, description: String, checked: Bool, dueDate: Bool, index: Int, key: String)
    {
        let object :[String: Any] =  ["name":name,"due-date":date,"description":description,"checked":checked,"due-date-specified":dueDate,"index":index,"id":key]
        database.child(key).setValue(object)
        tableView.reloadData()
    }
    func editTask(task: Task , name: String)
    {
        print("\(name)")
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
                destination.key=data.task.key
            }
            
            destination.delegate=self
        }
    }
}
