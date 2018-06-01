//
//  NewTaskViewController.swift
//  dotdos
//
//  Created by Gabriela Schirmer  | Stone on 01/06/18.
//  Copyright © 2018 Gabriela Schirmer Mauricio. All rights reserved.
//

import Eureka
import UIKit

class NewTaskViewController: FormViewController {
    

    enum RepeatFrequency: String {
        case never = "Never"
        case everyday = "Everyday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
        case everyweek = "Every week"
        case everymonth = "Every month"
        case everyyear = "Every year"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow() { row in
                row.placeholder = "Task"
            }
            <<< DateInlineRow() {
                $0.title = "Date"
                $0.value = Date()
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
