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
        
        // table view
        self.mytableview.tableFooterView = UIView()
        self.mytableview.register(UINib(nibName: "AddCell", bundle: nil), forCellReuseIdentifier: "addCell")
        self.mytableview.backgroundColor = UIColor(patternImage: UIImage(named: "pattern.png")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddCell
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = .disclosureIndicator
        cell.title.text = listTitle[indexPath.row]
        cell.img.image = listImg[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segue = "goToAdd" + listTitle[indexPath.row]
        performSegue(withIdentifier: segue, sender: self)
    }
}
