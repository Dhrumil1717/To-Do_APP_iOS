//
//  AddTaskViewController.swift
//  Assignment4
//
//  Created by Dhrumil Malaviya on 2020-11-13.
//  Copyright © 2020 Dhrumil Malaviya. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol AddTask
{
    func addTask (name:String, date: String, description: String, checked: Bool, dueDate: Bool, index: Int, key: String)
    func deleteTask(key:String)
    func editTask (task : Task , name:String)
    func editTask2( name:String, date: String, description: String, checked: Bool, dueDate: Bool, index: Int, key: String)
}


class AddTaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate
{
    
    //MARK: - Outlets
    
    @IBOutlet weak var addNewItemOutlet: UIButton!
    @IBOutlet weak var taskNameOutlet: UITextField!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var isCompletedSwitch: UISwitch!
    
    //MARK: - Variables
    var currentDate : String = ""
    var name :String = ""
    var desc: String = ""
    var fetchDueDate :Bool = true
    var fetchIsComplete : Bool = false
    var isComplete : Bool = false
    var dueDateBool = true
    var taskAction : TaskAction = .Add
    var delegate : AddTask? // used to transfer data from "AddTaskViewController" --> to "ViewController"
    var index = 0
    var key = ""
    
    let database = Database.database().reference()
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - View Controller Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        //assigning values if the user has already entered it
        taskNameOutlet.text=name
        descriptionOutlet.text = desc
        isCompletedSwitch.isOn=fetchIsComplete
        dueDateSwitch.isOn=fetchDueDate
        if desc == ""
        {
            descriptionOutlet.text = "Enter description"
            descriptionOutlet.textColor = UIColor.lightGray
            isCompletedSwitch.isOn=false
            dueDateSwitch.isOn=false
        }
        descriptionOutlet.delegate=self
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        if currentDate == ""
        {
            datePicker.date = Date()
        }
        else
        {
            // currentDate=dateFormatter.string(from: Date())
            let newdate = dateFormatter.date(from: currentDate)
            // let date = dateFormatter.date(from:currentDate)!
            datePicker.date = newdate ?? Date()
        }
        view.endEditing(true)
        
        switch taskAction
        {
        case .Add:
            addNewItemOutlet.setImage(UIImage(systemName: "plus"), for:.normal )
        case .Edit:
            addNewItemOutlet.setImage(UIImage(systemName: "pencil.and.ellipsis.rectangle"), for:.normal )
        }
        
        if dueDateSwitch.isOn==false
        {
            datePicker.isEnabled=false
        }
        if taskNameOutlet.text == ""
        {
            descriptionOutlet.isHidden = true
            dueDateSwitch.isHidden=true
            isCompletedSwitch.isHidden=true
        }
        taskNameOutlet.delegate=self
        dueDateBool = dueDateSwitch.isOn
        isComplete = isCompletedSwitch.isOn
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if  textField.text != ""
        {
            descriptionOutlet.isHidden = false
            dueDateSwitch.isHidden=false
            isCompletedSwitch.isHidden=false}
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = "Enter description"
            textView.textColor = UIColor.lightGray
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
    
    // MARK: - Objective C Methods
    
    @objc func dateChanged(_ datePicker:UIDatePicker)
    {
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        view.endEditing(true)
        currentDate=dateFormatter.string(from: datePicker.date)
    }
    // MARK: - On Button Clicked Methods
    
    //-----------------------------------------------DELETE BUTTON CLICKED-------------------------------------
    @IBAction func DeleteButton(_ sender: UIButton)
    {
        
        let alert = UIAlertController .init(title: "Delete", message: "Are you sure you want to DELETE this task?", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in () } ))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            ( self.delegate?.deleteTask(key: self.key ))
            self.navigationController?.popViewController(animated: true)
        } ))
        present(alert,animated: true)
    }
    //-----------------------------------------------CANCEL BUTTON CLICKED--------------------------------------
    
    @IBAction func CancelButton(_ sender: Any)
    {
        showAlert()
    }
    
    func showAlert()
    {
        let alert = UIAlertController.init(title: "Cancel", message: "Are you sure you want to clear all entries ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in () }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            self.taskNameOutlet.text=""
            self.descriptionOutlet.text=""
            self.dueDateSwitch.isOn=false
            self.isCompletedSwitch.isOn=false
            let date = Date()
            self.datePicker.date = date
            
        }))
        present(alert,animated: true)
    }
    //-----------------------------------------------ADD BUTTON CLICKED-----------------------------------------
    
    @IBAction func AddButton(_ sender: Any)
    {
        switch taskAction{
        case .Add:
            if taskNameOutlet.text != ""
            {
                delegate?.addTask(name: taskNameOutlet.text!, date: currentDate, description: descriptionOutlet.text, checked: isComplete, dueDate: dueDateBool, index: index,key: "" )
            }
            
        case .Edit:
            
            let alert = UIAlertController.init(title: "Update", message: "All the entries will be updated \n Are you sure you want to proceed?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in ()
                
            }))
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
                
                if self.taskNameOutlet.text != ""
                {
                    
                    self.delegate?.editTask2(name: self.taskNameOutlet.text!, date: self.currentDate, description: self.descriptionOutlet.text, checked: self.isComplete, dueDate: self.dueDateBool, index: self.index,key: self.key)
                    //                    self.delegate?.editTask(task: Task(name: self.taskNameOutlet.text!, date: self.currentDate, description: self.descriptionOutlet.text, checked: self.isComplete, dueDate: self.dueDateBool, index: self.index,key:self.key), name: self.taskNameOutlet.text!)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }))
            present(alert,animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
    //-----------------------------------------------DUE DATE SWITCH------------------------------------------
    @IBAction func dueDateSwitchAction(_ sender: Any)
    {
        if dueDateSwitch.isOn
        {
            dueDateBool=true
            datePicker.isEnabled=true
        }
        else
        {
            dueDateBool=false
            datePicker.isEnabled=false
        }
    }
    
    //-----------------------------------------------IS COMPLETED SWITCH-----------------------------------------
    
    @IBAction func IsCompleted(_ sender: UISwitch)
    {
        if sender.isOn
        {
            isComplete = true
        }
        else
        {
            isComplete = false
        }
        
    }
}



