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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addTask))
        
        form +++ Section()
            <<< TextRow() { row in
                row.title = "Tarefa"
                row.tag = "title"
                row.placeholder = "Comprar pão"
            }
            <<< DateInlineRow() { row in
                row.title = "Data"
                row.tag = "date"
                row.value = Date()
            }
            <<< SwitchRow() { row in
                row.title = "Importante"
                row.tag = "important"
            }
            <<< TextAreaRow() { row in
                row.placeholder = "Descrição, nota ou lista"
                row.tag = "detail"
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func addTask() {
        let titlerow: TextRow? = form.rowBy(tag: "title")
        let daterow: DateInlineRow? = form.rowBy(tag: "date")
        let importantrow: SwitchRow? = form.rowBy(tag: "important")
        let detailrow: TextAreaRow? = form.rowBy(tag: "detail")
        let titleValue = titlerow?.value
        let dateValue = daterow?.value
        let importantValue = importantrow?.value
        let detailValue = detailrow?.value

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        let newTask = NSManagedObject(entity: entity!, insertInto: context)
        newTask.setValue(titleValue, forKey: "title")
        newTask.setValue(dateValue, forKey: "date")
        newTask.setValue(importantValue, forKey: "important")
        newTask.setValue(detailValue, forKey: "detail")

        do {
            try context.save()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Failed saving")
        }


    }
}
