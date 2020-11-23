//
//  Task.swift
//  Assignment4
//
//  Created by Dhrumil Malaviya on 2020-11-22.
//  Copyright © 2020 Dhrumil Malaviya. All rights reserved.
//

import Foundation

class Task                  //creating a class and adding one parameter to make a call
{
    var name = ""
    var checked = false
    var date = ""
    var description = ""
    var dueDate = true
    var index = 0
    
    convenience init (name : String, date : String, description: String, checked : Bool, dueDate : Bool, index : Int)
    {
        
        self.init()
        self.name = name
        self.date = date
        self.description = description
        self.checked = checked
        self.dueDate = dueDate
        self.index=index
        
    }
    
}

enum TaskAction {
    case Add
    case Edit
}
