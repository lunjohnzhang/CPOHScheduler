//
//  CalendarVC.swift
//  
//
//  Created by LunJohnZhang on 2019/4/13.
//

import UIKit
import CalendarKit
import CalendarSwift

class CalendarVC: UIViewController, CalendarViewDelegate {
    
    @IBOutlet weak var calendar: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.style.language = "en"
        calendar.style.bgColor = UIColor(rgb: 0xeeeeee)
        calendar.style.indicatorCellColor = UIColor(rgb: 0x00adb5)
        calendar.style.monthViewTitleColor = UIColor(rgb: 0x222831)
        calendar.style.monthViewBackgroundColor = UIColor(rgb: 0xeeeeee)
        calendar.style.monthViewBtnLeftColor = UIColor(rgb: 0x222831)
        calendar.style.monthViewBtnRightColor = UIColor(rgb: 0x222831)
        calendar.style.activeCellLblColor = UIColor(rgb: 0x222831)
        calendar.style.switcherIndicatorColor = UIColor(rgb: 0x00adb5)
        calendar.style.switcherSelectedTitleColor = UIColor(rgb: 0x222831)
        calendar.style.yearBackgroundColor = UIColor(rgb: 0xeeeeee)
        calendar.setupCalendar()
        
        // Do any additional setup after loading the view.
    }
    
    func calendarDateChanged(date: Date) {
        print(date.description)
        let selectedDate = date.description.components(separatedBy: " ")[0]
        print("selected:\(selectedDate)\n")
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
