//
//  AddNoteViewController.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 01/04/18.
//  Copyright © 2018 Gabriela Schirmer Mauricio. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mytableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        self.mytableview.tableFooterView = UIView()
        self.mytableview.backgroundColor = UIColor(patternImage: UIImage(named: "pattern.png")!)
        initCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initCell () {
        self.mytableview.register(UINib(nibName: "TextInputCell", bundle: nil), forCellReuseIdentifier: "textInputCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "textInputCell", for: indexPath) as! TextInputCell
        }
        
        return cell
    }
}


