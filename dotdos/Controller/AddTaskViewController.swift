//
//  AddItemViewController.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 30/03/18.
//  Copyright © 2018 Gabriela Schirmer Mauricio. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var mytableview: UITableView!
    
    var datePickerIndexPath: NSIndexPath?

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
        self.mytableview.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "datePickerCell")
        self.mytableview.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
    }
    
    @IBAction func saveTask(_ sender: Any) {
        print("save pressed")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 2
        if datePickerIndexPath != nil {
            rows += 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! DatePickerCell
        } else {
            if indexPath.row == 0 {
                cell = TextInputCell()
                cell = tableView.dequeueReusableCell(withIdentifier: "textInputCell", for: indexPath) as! TextInputCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates() // because there are more than one action below
        if datePickerIndexPath != nil && datePickerIndexPath!.row - 1 == indexPath.row {
            tableView.deleteRows(at: [datePickerIndexPath! as IndexPath], with: .fade)
            datePickerIndexPath = nil
        } else {
            if datePickerIndexPath != nil {
                tableView.deleteRows(at: [datePickerIndexPath! as IndexPath], with: .fade)
            }
            datePickerIndexPath = calculateDatePickerIndexPath(indexPathSelected: indexPath as NSIndexPath)
            tableView.insertRows(at: [datePickerIndexPath! as IndexPath], with: .fade)
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        tableView.endUpdates()
    }
    
    func calculateDatePickerIndexPath(indexPathSelected: NSIndexPath) -> NSIndexPath {
        if datePickerIndexPath != nil && datePickerIndexPath!.row  < indexPathSelected.row {
            return NSIndexPath(row: indexPathSelected.row, section: 0)
        } else {
            return NSIndexPath(row: indexPathSelected.row + 1, section: 0)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = tableView.rowHeight
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell") as!  DatePickerCell
            rowHeight = cell.frame.height
        }
        return rowHeight
    }
    
}

