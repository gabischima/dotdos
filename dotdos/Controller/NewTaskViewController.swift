//
//  NewTaskViewController.swift
//  dotdos
//
//  Created by Gabriela Schirmer  | Stone on 01/06/18.
//  Copyright © 2018 Gabriela Schirmer Mauricio. All rights reserved.
//

import Eureka
import UIKit
import CoreData

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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addTapped))
        
        
        form +++ Section()
            <<< TextRow() { row in
                row.title = "Tarefa"
                row.tag = "title"
                row.placeholder = "Comprar pão"
            }
//            <<< DateInlineRow() {
//                $0.title = "Date"
//                $0.value = Date()
//            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func addTapped() {
        let row: TextRow? = form.rowBy(tag: "title")
        let value = row?.value

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        let newTask = NSManagedObject(entity: entity!, insertInto: context)
        newTask.setValue(value, forKey: "title")
        
        do {
            try context.save()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Failed saving")
        }


    }
}
