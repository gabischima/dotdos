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
    
    var task = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        cell.textLabel?.text = task
        
        return cell
        
    }
    
}
