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
    
    // MARK:- Variables
    
    var navigationTitle: String = ""

    var tasksLeft: [Tasks] = []
    var tasksMiddle: [Tasks] = []
    var tasksRight: [Tasks] = []

    var selectedTask: Tasks!
    var selectedDate: Date = Date()

    var tableViewLeft = UITableView()
    var tableViewMiddle = UITableView()
    var tableViewRight = UITableView()
    
    // MARK:- IBOutlet
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    // MARK:- Life cycle

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
        
        self.view.addSubview(calendar)
        
        // change navigation bar
        self.navigationTitle = formatDate(date: self.calendar.currentPage, format: "LLLL")
        self.navigationController?.navigationBar.topItem?.title = self.navigationTitle
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        setUpTableViews()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchFromCore(date: self.selectedDate)
        self.reloadTableView()
    }
    
    // MARK:- Functions
    
    func setUpTableViews () {
        self.tableViewLeft.tableFooterView = UIView()
        self.tableViewLeft.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        
        self.tableViewMiddle.tableFooterView = UIView()
        self.tableViewMiddle.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        
        self.tableViewRight.tableFooterView = UIView()
        self.tableViewRight.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        
        self.tableViewLeft.backgroundColor = UIColor.clear
        self.tableViewMiddle.backgroundColor = UIColor.clear
        self.tableViewRight.backgroundColor = UIColor.clear

        self.myScrollView.delegate = self
        
        self.tableViewLeft.delegate = self
        self.tableViewMiddle.delegate = self
        self.tableViewRight.delegate = self
        
        self.tableViewLeft.dataSource = self
        self.tableViewMiddle.dataSource = self
        self.tableViewRight.dataSource = self
        
        self.tableViewLeft.tag = 0
        self.tableViewMiddle.tag = 1
        self.tableViewRight.tag = 2
        
        self.tableViewLeft.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableViewMiddle.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableViewRight.frame = CGRect(x: self.view.frame.width * 2, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.myScrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0.0), animated: false)
        self.myScrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        
        self.myScrollView.addSubview(self.tableViewLeft)
        self.myScrollView.addSubview(self.tableViewMiddle)
        self.myScrollView.addSubview(self.tableViewRight)
    }
    
    func reloadTableView () {
        self.tableViewLeft.reloadData()
        self.tableViewMiddle.reloadData()
        self.tableViewRight.reloadData()
    }
    
    func fetchFromCore(date: Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        self.tasksLeft.removeAll()
        self.tasksMiddle.removeAll()
        self.tasksRight.removeAll()
        
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
                        self.tasksMiddle.append(data)
                    } else if Calendar.current.compare(resultDate, to: date.nextDay, toGranularity: .day) == .orderedSame {
                        self.tasksRight.append(data)
                    } else if Calendar.current.compare(resultDate, to: date.previousDay, toGranularity: .day) == .orderedSame {
                        self.tasksLeft.append(data)
                    }
                }
            }
        } catch {
            print("Failed")
        }
    }

    // MARK:- IBAction

    @IBAction func goToToday(_ sender: Any) {
        self.calendar.select(Date(), scrollToDate: true)
        self.reloadTableView()
    }
    
    @IBAction func toggleCalendar(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: false)
        } else {
            self.calendar.setScope(.month, animated: false)
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

// MARK:- ScrollView Delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x == 0.0) {
            self.selectedDate = self.selectedDate.previousDay
        } else if (scrollView.contentOffset.x == self.view.frame.width * 2) {
            self.selectedDate = self.selectedDate.nextDay
        }

        if (scrollView.contentOffset.x != self.view.frame.width) {
            self.calendar.select(self.selectedDate, scrollToDate: true)
            fetchFromCore(date: self.selectedDate)
            self.reloadTableView()
            self.myScrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0.0), animated: false)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

// MARK:- TableView Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return self.tasksLeft.count
        case 1:
            return self.tasksMiddle.count
        case 2:
            return self.tasksRight.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        var arr: [Tasks] = []
        
        switch tableView.tag {
        case 0:
            arr = self.tasksLeft
            break
        case 1:
            arr = self.tasksMiddle
            break
        case 2:
            arr = self.tasksRight
            break
        default:
            break
        }

        var img = #imageLiteral(resourceName: "task").withRenderingMode(.alwaysTemplate)
        cell.img.image = img
        cell.img.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.selectionStyle = .none

        let text = arr[indexPath.row].value(forKey: "title") as? String
        let attributeString =  NSMutableAttributedString(string: text ?? "")

        let done = arr[indexPath.row].value(forKey: "done") as? Bool

        if done ?? false {
            img = #imageLiteral(resourceName: "taskDone").withRenderingMode(.alwaysTemplate)
            cell.img.image = img
            
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
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
            
            let donevalue = self.tasksMiddle[indexPath.row].done

            if let result = try? context.fetch(fetchRequest) {
                for data in result {
                    if data.objectID.description == self.tasksMiddle[indexPath.row].objectID.description {
                        data.setValue(!donevalue, forKey: "done")
                    }
                }
            }

            do {
                try context.save()
                self.tasksMiddle[indexPath.row].setValue(!donevalue, forKey: "done")
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
                    if data.objectID.description == self.tasksMiddle[indexPath.row].objectID.description {
                        context.delete(data)
                    }
                }
            }

            do {
                try context.save()
                self.tasksMiddle.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            } catch {
                print("Failed saving")
            }

            success(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteTask])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTask = self.tasksMiddle[indexPath.row]
        performSegue(withIdentifier: "goToTaskDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView.tag {
        case 0:
            return formatDate(date: self.calendar.selectedDate!.previousDay, format: "dd/MM/yyyy")
        case 1:
            return formatDate(date: self.calendar.selectedDate!, format: "dd/MM/yyyy")
        case 2:
            return formatDate(date: self.calendar.selectedDate!.nextDay, format: "dd/MM/yyyy")
        default:
            return formatDate(date: self.calendar.selectedDate!, format: "dd/MM/yyyy")
        }
    }
}

// MARK:- FSCalendar Delegate
extension HomeViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // resize calendar to week size
        switch (calendar.scope) {
        case .week:
            self.calendarHeight.constant = 81.361
        case .month:
            self.calendarHeight.constant = 274.0
        }
        self.reloadTableView()
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
        self.reloadTableView()
    }
    
}
