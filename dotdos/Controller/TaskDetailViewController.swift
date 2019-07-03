//
//  TaskDetail.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 16/06/19.
//  Copyright © 2019 Gabriela Schirmer Mauricio. All rights reserved.
//

import Foundation
import CoreData

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var task: Tasks!
    
    enum TasksFields: CaseIterable {
        case title
        case date
        case detail
        case important
        case delete
    }

    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func showDeleteAlert() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.deleteTask()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deleteTask() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
        
        if let result = try? context.fetch(fetchRequest) {
            for data in result {
                if data.objectID.description == self.task.objectID.description {
                    context.delete(data)
                }
            }
        }
        
        do {
            try context.save()
            _ = navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Failed saving")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TasksFields.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = task.value(forKey: "title") as? String
            break
        case 1:
            if let value = task.value(forKey: "date") as? Date {
                cell.textLabel?.text = formatDate(date: value, format: "dd/MM/yyyy")
            } else {
                cell.textLabel?.text = "---"
            }
            break
        case 2:
            if let value = task.value(forKey: "detail") as? String {
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.textLabel?.text = value
            } else {
                cell.textLabel?.text = "---"
            }
            break
        case 3:
            let value = task.value(forKey: "important") as? Bool
            if value != nil {
                if value ?? false {
                    cell.textLabel?.text = "Importante"
                } else {
                    cell.textLabel?.text = "---"
                }
            } else {
                cell.textLabel?.text = "---"
            }
            break
        case 4:
            let btn = UIButton(type: .system)
            btn.setTitle("Delete", for: .normal)
            btn.tintColor = .red
            btn.addTarget(self, action: #selector(showDeleteAlert), for: .touchUpInside)
            btn.titleLabel?.sizeToFit()
            btn.frame.size = btn.titleLabel?.frame.size ?? CGSize(width: 10.0, height: 10.0)
            cell.contentView.addSubview(btn)
            btn.center = CGPoint(x: self.view.center.x, y: cell.contentView.center.y)

            break
        default:
            break
        }
        
        return cell
    }
    
}
