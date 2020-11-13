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
    func addTask (name:String)
}
class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskNameOutlet: UITextField!
   
   
    var delegate : AddTask?
    @IBAction func AddButton(_ sender: Any)
    {
        if taskNameOutlet.text != ""
        {
            delegate?.addTask(name: taskNameOutlet.text!)
            navigationController?.popViewController(animated: true)
        }
    }
    
   
  

    override func viewDidLoad()
       {
           super.viewDidLoad()
       }
}
