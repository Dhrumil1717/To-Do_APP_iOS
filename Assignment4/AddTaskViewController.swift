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
    func addTask (name:String, date: String)
}

class AddTaskViewController: UIViewController{

    @IBOutlet weak var taskNameOutlet: UITextField!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
   
    var currentDate : String = ""
    var name :String = ""
    
    var delegate : AddTask?
    
    @IBAction func AddButton(_ sender: Any)
    {
        if taskNameOutlet.text != ""
        {
            delegate?.addTask(name: taskNameOutlet.text!, date: currentDate)
            navigationController?.popViewController(animated: true)
        }
    }
    
   
    
    @IBAction func dueDateSwitchAction(_ sender: Any)
    {
        if dueDateSwitch.isOn
        {
            datePicker.isEnabled=true
        }
        else
        {
            datePicker.isEnabled=false
        }
    }
    
    
    override func viewDidLoad()
       {
           super.viewDidLoad()
        taskNameOutlet.text=name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        currentDate=dateFormatter.string(from: Date())
        
        let date = dateFormatter.date(from:currentDate)!
         datePicker.date=date
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // set date
                view.endEditing(true)
                
       }
    
    @objc func dateChanged(_ datePicker:UIDatePicker)
    {
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
//        taskNameOutlet.text=dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        currentDate=dateFormatter.string(from: datePicker.date)
    }

}
