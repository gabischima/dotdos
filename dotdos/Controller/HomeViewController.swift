//
//  HomeViewController.swift
//  dotdos
//
//  Created by Gabriela Schirmer Mauricio on 12/02/18.
//  Copyright © 2018 Gabriela Schirmer Mauricio. All rights reserved.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var navigationTitle: String = ""
    
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
        
        self.mytableview.addSubview(calendar)
        
        // change navigation bar
        self.navigationTitle = getMonth(date: self.calendar.currentPage)
        self.navigationController?.navigationBar.topItem?.title = self.navigationTitle
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        self.mytableview.tableFooterView = UIView()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern.png")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mytableview.reloadData()
    }
    
    // MARK:- Functions
    
    func getMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        return nameOfMonth
    }
    
    // go to day today
    @IBAction func goToToday(_ sender: Any) {
        self.calendar.select(Date(), scrollToDate: true)
    }
    
    @IBAction func toggleCalendar(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
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
        self.navigationTitle = getMonth(date: self.calendar.currentPage)
        
        self.navigationController?.navigationBar.topItem?.title = self.navigationTitle
        //        let month = Calendar.current.component(.month, from: currentPageDate)
    }
    
    // MARK:- TableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        return cell
    }
    
    // MARK:- Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
}


