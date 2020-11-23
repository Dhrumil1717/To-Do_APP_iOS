//
//  AddTaskViewController.swift
//  Assignment4
//
//  Created by Dhrumil Malaviya on 2020-11-13.
//  Copyright © 2020 Dhrumil Malaviya. All rights reserved.
//

import UIKit

protocol AddTask
{
    func addTask (name:String, date: String, description: String, checked: Bool, dueDate: Bool, index: Int)
    func deleteTask(index: Int)
    func editTask (task : Task)
}


class AddTaskViewController: UIViewController, UITextViewDelegate
{

    //MARK: - Outlets
    
    @IBOutlet weak var addNewItemOutlet: UIButton!
    @IBOutlet weak var taskNameOutlet: UITextField!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var isCompletedOutlet: UISwitch!
    
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
    var index=0
    
    //MARK: - View Controller Methods
    
    override func viewDidLoad()
           {
            super.viewDidLoad()
            
            //assigning values if the user has already entered it
            taskNameOutlet.text=name
            descriptionOutlet.text = desc
            isCompletedOutlet.isOn=fetchIsComplete
            dueDateSwitch.isOn=fetchDueDate
            if desc == ""
                {
                descriptionOutlet.text = "Enter description"
                descriptionOutlet.textColor = UIColor.lightGray
                isCompletedOutlet.isOn=false
                }
                descriptionOutlet.delegate=self
            
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            currentDate=dateFormatter.string(from: Date())
            
            let date = dateFormatter.date(from:currentDate)!
            datePicker.date=date
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
        
           }
   
    func textViewDidBeginEditing(_ textView: UITextView)
        {
           if textView.textColor == UIColor.lightGray
                         {
                             textView.text = nil
                             textView.textColor = UIColor.black
                         }
            }
    func textViewDidEndEditing(_ textView: UITextView)
        {
             if textView.text.isEmpty
                           {
                                   textView.text = "Enter description"
                                   textView.textColor = UIColor.lightGray
                           }
        }
    func textFieldShouldReturn(_ textView: UITextView) -> Bool //dismiss the keyboard when user presses return button
       {
            textView.resignFirstResponder()
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
                                                                                    ( self.delegate?.deleteTask(index: self.index))
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
                delegate?.addTask(name: taskNameOutlet.text!, date: currentDate, description: descriptionOutlet.text, checked: isComplete, dueDate: dueDateBool, index: index )
            }
            
        case .Edit:
           if taskNameOutlet.text != ""
            {
                delegate?.editTask(task: Task(name: taskNameOutlet.text!, date: currentDate, description: descriptionOutlet.text, checked: isComplete, dueDate: dueDateBool, index: index))
            }
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

 

