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

class HomeViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var navigationTitle: String = ""
    
    var tasks: [Any] = []
    
    var selectedTask: Any = ()
    
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
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
        
        self.mytableview.addSubview(calendar)
        
        // change navigation bar
        self.navigationTitle = formatDate(date: self.calendar.currentPage, format: "LLLL")
        self.navigationController?.navigationBar.topItem?.title = self.navigationTitle
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        self.mytableview.tableFooterView = UIView()
        self.mytableview.register(UINib(nibName: "DayCell", bundle: nil), forCellReuseIdentifier: "dayCell")

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchFromCore()
        self.mytableview.reloadData()
    }
    
    // MARK:- Functions
    
    func formatDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.string(from: date)
        return date
    }
    
    @IBAction func goToToday(_ sender: Any) {
        self.calendar.select(Date(), scrollToDate: true)
        self.mytableview.reloadData()
    }
    
    @IBAction func toggleCalendar(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: false)
        } else {
            self.calendar.setScope(.month, animated: false)
        }
    }
    
    func fetchFromCore() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.tasks.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                tasks.append(data.value(forKey: "title") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    
    // MARK:- FSCalendar Methods
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // resize calendar to week size
        switch (calendar.scope) {
            case .week:
                self.calendar.frame.size.height = 81.361
            case .month:
                self.calendar.frame.size.height = 274.0
        }
        self.mytableview.reloadData()
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.navigationTitle = formatDate(date: self.calendar.currentPage, format: "LLLL")
        
        self.navigationController?.navigationBar.topItem?.title = self.navigationTitle
        //        let month = Calendar.current.component(.month, from: currentPageDate)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.mytableview.reloadData()
    }
    
    // MARK:- TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayCell
        let img = #imageLiteral(resourceName: "task").withRenderingMode(.alwaysTemplate)
        cell.img.image = img
        cell.img.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.selectionStyle = .none
        cell.title.text = tasks[indexPath.row] as? String
        cell.subtitle.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // remove the deleted item from the model
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")

            if let result = try? context.fetch(fetchRequest) {
                context.delete(result[indexPath.row] as! NSManagedObject)
            }

            do {
                try context.save()
                tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            } catch {
                print("Failed saving")
            }
        default:
            return
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: "goToTaskDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formatDate(date: self.calendar.selectedDate!, format: "dd/MM/yyyy")
    }
    
    // MARK:- Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "goToTaskDetail" {
            let nextVC = (segue.destination as! TaskDetailViewController)
            nextVC.task = self.selectedTask as! String
        }
    }
}


