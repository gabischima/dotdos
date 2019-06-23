//
//  TaskDetail.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 16/06/19.
//  Copyright © 2019 Gabriela Schirmer Mauricio. All rights reserved.
//

import Foundation
import UIKit

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var task: Tasks!
    
    enum TasksFields: CaseIterable {
        case title
        case date
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TasksFields.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
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
            default:
                break
        }
        
        return cell
        
    }
    
}
