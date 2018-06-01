//
//  AddViewController.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 19/03/18.
//  Copyright © 2018 Gabriela Schirmer Mauricio. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mytableview: UITableView!
    
    let listTitle: [String] = ["Task", "Event", "Note"]
    let listImg: [UIImage] = [#imageLiteral(resourceName: "task"), #imageLiteral(resourceName: "event"), #imageLiteral(resourceName: "note")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mytableview.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.imageView?.image = listImg[indexPath.row]
        cell.textLabel?.text = listTitle[indexPath.row]
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "goToAddTask", sender: self)
        default:
            break
        }
    }
}
