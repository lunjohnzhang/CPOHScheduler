//
//  RescheduleVC.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/17.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import UIKit
import TenClock
import CalendarSwift

class RescheduleVC: UIViewController {
    // sharedInstances
    let appointmentModel = AppointmentModel.sharedInstance
    
    // IBOutlets
    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var clock: TenClock!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    // choose time variables
    var eventToChange: EventWithId? // extend provided event class to store id
    var chooseStartDate: String? // start date chosen by the user (MM/dd)
    var chooseEndDate: String? // end date chosen by the user (MM/dd)
    var chooseStartTime: String? // start time chosen by the user (HH:mm)
    var chooseEndTime: String? // end time chosen by the user (HH:mm)
    var prevChoosenSHour: Int? // previous chosen start hour
    var prevChoosenEHour: Int? // previous chosen end hour
    var crossTwoDay: Bool = false // whether two days choosen cross over two days
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.backgroundColor = Global.cusWhite
        setUpCalendarUI()
        setupClockUI()
        naviBar.backgroundColor = Global.cusWhite
    }
    
    // reschedule done, send request to the server
    @IBAction func rescheduleDone(_ sender: UIBarButtonItem) {
        print("done pressed")
        // first delete the original event
        if let event = eventToChange, let sd = chooseStartDate, let st = chooseStartTime, let ed = chooseEndDate, let et = chooseEndTime {
            // get the updated start and end time
            let formatter = Helper.getFormatter(format: "yyyy-MM/dd HH:mm")
            let startDateTime = formatter.date(from: "\(sd) \(st)")
            let endDateTime = formatter.date(from: "\(ed) \(et)")
            
            // make the request
            if let newStart = startDateTime, let newEnd = endDateTime {
                event.startDate = newStart
                event.endDate = newEnd
                appointmentModel.updateEvent(Global.calendarId, changeTo: event) {
                    (success, error) in
                    // if successfully updated, get new event
                    if(success) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    // if not, show the error message
                    else{
                        
                    }
                }
            }
        }
    }
    
    
    // reschedule canceled, pop the current view
    @IBAction func rescheduleCanceled(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension RescheduleVC: CalendarViewDelegate {
    
    // delegate method when the calendar day changed
    func calendarDateChanged(date: Date) {
        // update the currently selected year and date
        updateChosenDate()
        updateTimeLabel()
    }
    
    
    func setUpCalendarUI() {
        calendar.delegate = self
        calendar.style.language = "en"
        calendar.style.bgColor = Global.cusWhite
        calendar.style.indicatorCellColor = Global.cusGreen
        calendar.style.monthViewTitleColor = Global.cusDark
        calendar.style.monthViewBackgroundColor = Global.cusWhite
        calendar.style.monthViewBtnLeftColor = Global.cusDark
        calendar.style.monthViewBtnRightColor = Global.cusDark
        calendar.style.activeCellLblColor = Global.cusDark
        calendar.style.switcherIndicatorColor = Global.cusGreen
        calendar.style.switcherSelectedTitleColor = Global.cusDark
        calendar.style.yearBackgroundColor = Global.cusWhite
        calendar.setupCalendar()
        if let event = eventToChange {
            calendar.selectedDate = event.startDate
            print("selected changed: \(calendar.selectedDate)")
            updateChosenDate()
        }
    }
}

extension RescheduleVC: TenClockDelegate {
    // called everytime the user lift his/her finger
    func timesChanged(_ clock: TenClock, startDate: Date, endDate: Date) {
//        print("in times changed")
//        let formatter = Helper.getFormatter(format: "yyyy-MM-dd HH:mm")
//        print("clock start date: \(formatter.string(from: startDate))")
//        print("clock start date: \(formatter.string(from: endDate))")
//        print()
    }
    
    // called every time the clock time changed
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) {
        // update chooseStartTime and chooseEndTime
        let formatter = Helper.getFormatter(format: "HH:mm")
        chooseStartTime = formatter.string(from: startDate)
        chooseEndTime = formatter.string(from: endDate)
        
        // update chosen dates and label
        updateTimeCrossTwoDay()
        updateTimeLabel()
    }
    
    
    func setupClockUI() {
        clock.delegate = self
        clock.backgroundColor = Global.cusWhite
        clock.headBackgroundColor = Global.cusWhite
        clock.tailBackgroundColor = Global.cusWhite
        
        self.view.tintColor = Global.cusGreen
        if let event = eventToChange, let end = Helper.getAjacentDateByMinute(date: event.endDate, by: 2)   {
            // set up initial clock time
            clock.startDate = event.startDate
            clock.endDate = end
            
            // set up initial choosen startTime and endTime
            let formatter = Helper.getFormatter(format: "HH:mm")
            chooseStartTime = formatter.string(from: event.startDate)
            chooseEndTime = formatter.string(from: end)
            
            // end date may change
            let formatter_ = Helper.getFormatter(format: "yyyy-MM/dd")
            chooseEndDate = formatter_.string(from: end)
            
            // set up initial hour and end hour --> used for UI updating while time updated
            prevChoosenSHour = event.startDate.hour
            prevChoosenEHour = end.hour
            
            updateTimeLabel()
        }
    }
    
    func updateTimeCrossTwoDay() {
        if let st = chooseStartTime, let et = chooseEndTime {
            
            // update calendar date if time interval cross over two days
            let sHour = Int(st.split(separator: ":")[0])
            let eHour = Int(et.split(separator: ":")[0])
            
            if let sHour = sHour, let eHour = eHour, let prevSHour = prevChoosenSHour, let prevEHour = prevChoosenEHour {
                // if start hour change from 0 to 23, start date decrement
                if(prevSHour == 0 && sHour == 23 && !crossTwoDay) {
                    crossTwoDay = true
                }
                    
                // if end hour change from 23 to 0, end date increment
                if(prevEHour == 23 && eHour == 0 && !crossTwoDay) {
                    crossTwoDay = true
                }
                if ((prevSHour == 23 && sHour == 0 ) || (prevEHour == 0 && eHour == 23)) {
                    crossTwoDay = false
                }
                
                updateChosenDate()
                prevChoosenSHour = sHour
                prevChoosenEHour = eHour
            }
        }
    }
    
    // function to update the month-date choosen
    func updateChosenDate() {
        let formatter = Helper.getFormatter(format: "yyyy-MM/dd")
        chooseStartDate = formatter.string(from: calendar.selectedDate)
        if (crossTwoDay) {
            if let tomorrow = Helper.getAjacentDateByDay(date: calendar.selectedDate, by: 2) {
                chooseEndDate = formatter.string(from: tomorrow)
            }
        }
        else {
            chooseEndDate = chooseStartDate
        }
    }
    
    // function to update the date-time label
    func updateTimeLabel() {
        if let st = chooseStartTime, let et = chooseEndTime, let sd = chooseStartDate, let ed = chooseEndDate {
            // update time label
            let sMonthDate = sd.split(separator: "-")[1]
            let eMonthDate = ed.split(separator: "-")[1]
            startTimeLabel.text = "\(sMonthDate) \(st)"
            endTimeLabel.text = "\(eMonthDate) \(et)"
            startTimeLabel.textColor = Global.cusDark
            endTimeLabel.textColor = Global.cusDark
            
            // if the chosen start day is after the chosen end day, warn the user
            let formatter = Helper.getFormatter(format: "yyyy-MM/dd HH:mm")
            let startDateTime = formatter.date(from: "\(sd) \(st)")
            let endDateTime = formatter.date(from: "\(ed) \(et)")
            if let sdt = startDateTime, let edt = endDateTime {
                if(sdt > edt) {
                    startTimeLabel.textColor = UIColor.red
                    endTimeLabel.textColor = UIColor.red
                }
            }
        }
    }
}
