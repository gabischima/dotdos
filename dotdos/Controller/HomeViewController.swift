//
//  HomeViewController.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 12/02/18.
//  Copyright © 2018 Gabriela Schirmer Mauricio. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class HomeViewController: UIViewController {
    
    var navigationTitle: String = ""
    
    var tasks: [Tasks] = []
    
    var selectedTask: Tasks!

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        // calendar appearance
        self.calendar?.appearance.weekdayFont = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]

        // set calendar to week
        self.calendar.scope = .week
        
        // remove calendar header
        self.calendar.headerHeight = 10
        self.calendar.appearance.headerTitleColor = UIColor.clear
        
        self.calendar.select(Date(), scrollToDate: false)
        
        self.myTableView.addSubview(calendar)
        
        // change navigation bar
        self.navigationTitle = formatDate(date: self.calendar.currentPage, format: "LLLL")
        self.navigationController?.navigationBar.topItem?.title = self.navigationTitle
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        self.myTableView.tableFooterView = UIView()
        self.myTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "taskCell")

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchFromCore(date: self.selectedDate)
        self.myTableView.reloadData()
    }
    
    // MARK:- Functions
    
    @IBAction func goToToday(_ sender: Any) {
        self.calendar.select(Date(), scrollToDate: true)
        self.myTableView.reloadData()
    }
    
    @IBAction func toggleCalendar(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: false)
        } else {
            self.calendar.setScope(.month, animated: false)
        }
    }
    
    func fetchFromCore(date: Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.tasks.removeAll()
        let request = NSFetchRequest<Tasks>(entityName: "Tasks")
        let sort = NSSortDescriptor(key: #keyPath(Tasks.date), ascending: true)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result {
                if data.value(forKey: "date") != nil {
                    let resultDate = data.value(forKey: "date") as! Date
                    if Calendar.current.compare(resultDate, to: date, toGranularity: .day) == .orderedSame {
                        self.tasks.append(data)
                    }
                }
            }
        } catch {
            print("Failed")
        }
    }

    // MARK:- Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "goToTaskDetail" {
            let nextVC = (segue.destination as! TaskDetailViewController)
            nextVC.task = self.selectedTask
        }
    }
}

// MARK:- TableView Delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell

        var img = #imageLiteral(resourceName: "task").withRenderingMode(.alwaysTemplate)
        cell.img.image = img
        cell.img.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.selectionStyle = .none

        let text = tasks[indexPath.row].value(forKey: "title") as? String
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text ?? "")

        let done = tasks[indexPath.row].value(forKey: "done") as? Bool

        if done ?? false {
            img = #imageLiteral(resourceName: "taskDone").withRenderingMode(.alwaysTemplate)
            cell.img.image = img
            
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        } else {
            attributeString.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        }
        
        cell.title.attributedText = attributeString

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markAsDone = UIContextualAction(style: .normal, title:  "Feito", handler: { (action:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            // remove the deleted item from the model
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
            let donevalue = self.tasks[indexPath.row].done

            if let result = try? context.fetch(fetchRequest) {
                for data in result {
                    if data.objectID.description == self.tasks[indexPath.row].objectID.description {
                        data.setValue(!donevalue, forKey: "done")
                    }
                }
            }

            do {
                try context.save()
                tableView.beginUpdates()
                self.tasks[indexPath.row].setValue(!donevalue, forKey: "done")
                tableView.endUpdates()
            } catch {
                print("Failed saving")
            }

            success(true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                tableView.reloadData()
            }
        })
        markAsDone.backgroundColor = .gray

        return UISwipeActionsConfiguration(actions: [markAsDone])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTask = UIContextualAction(style: .destructive, title:  "Deletar", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            // remove the deleted item from the model
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")

            if let result = try? context.fetch(fetchRequest) {
                for data in result {
                    if data.objectID.description == self.tasks[indexPath.row].objectID.description {
                        context.delete(data)
                    }
                }
            }

            do {
                try context.save()
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            } catch {
                print("Failed saving")
            }

            success(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteTask])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: "goToTaskDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formatDate(date: self.calendar.selectedDate!, format: "dd/MM/yyyy")
    }
}

// MARK:- FSCalendar Delegate

extension HomeViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // resize calendar to week size
        switch (calendar.scope) {
        case .week:
            self.calendar.frame.size.height = 81.361
        case .month:
            self.calendar.frame.size.height = 274.0
        }
        self.myTableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.navigationTitle = formatDate(date: self.calendar.currentPage, format: "LLLL")
        
        self.navigationController?.navigationBar.topItem?.title = self.navigationTitle
        //        let month = Calendar.current.component(.month, from: currentPageDate)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        fetchFromCore(date: date)
        self.myTableView.reloadData()
    }
    
}
