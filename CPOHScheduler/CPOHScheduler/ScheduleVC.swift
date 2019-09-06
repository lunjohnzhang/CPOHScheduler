//
//  DemoScheduleVC.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/16.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import UIKit
import CalendarKit
import WWCalendarTimeSelector

class ScheduleVC: DayViewController {
    // sharedInstances
    let appointmentModel = AppointmentModel.sharedInstance
    
    // other variables
    var classChosen: Class?
    var isStudent: Bool?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get class choosen
        let naviVC = self.navigationController as! NaviToScheduleVC
        self.classChosen = naviVC.classChosen
        self.isStudent = naviVC.isStudent
        
        // update UI
        let style = updateStyle()
        self.updateStyle(style)
        
        // get and load events of the current date
        if let reqDate = self.dayView.state?.selectedDate {
            appointmentModel.fetcheEvents("primary", reqDate) {
                (success, error) in
                if(success) {
                    DispatchQueue.main.async {
                        self.reloadData() // similar to .reloadData of tableView and collectionView
                    }
                }
            }
        }
        
        // fetch events every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
            timer in
            self.backgroundListEvents()
        }
    }
    
    // Return an array of EventDescriptors for particular date
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let appointments = appointmentModel.appointments
        var events = [EventWithId]()
        
        if let appointments = appointments {
            for appointment in appointments {
                // Create new EventView
                let event = EventWithId()
                // Specify information and looking of events
                event.Id = appointment.Id
                event.color = Global.cusGreen
                event.textColor = Global.cusDark
                event.startDate = appointment.startDate
                // distinction between adjacent events
                if let end =  Helper.getAjacentDateByMinute(date: appointment.endDate, by: -2){
                    event.endDate = end
                }
                else {
                    event.endDate = appointment.endDate
                }
                event.summary = appointment.title
                event.location = appointment.location
                event.text = "\(appointment.title)\n\(appointment.location ?? "")"
                events.append(event)
            }
        }
        return events
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        print("arrived at new date: \(date)")
        appointmentModel.fetcheEvents(Global.calendarId, date) {
            (success, error) in
            if(success) {
                DispatchQueue.main.async {
                    self.reloadData() // similar to .reloadData of tableView and collectionView
                }
            }
        }
    }
    
    // while an event selected, CP can reschedule his/her office hour, while for student, nothing happens
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        if let isStudent = isStudent {
            if(!isStudent) {
                let descriptor = eventView.descriptor as! EventWithId
                if let id = descriptor.Id {
                    print("event with Id \(id) clicked")
                    
                    // end repeated fetching while quiting the current view
                    timer?.invalidate()
                    
                    // switch to rescheduleVC
                    Helper.SwitchToRescheduleVC(event: descriptor, currVC: self)
                }
                else {
                    print("No able to obtain id of the event")
                }
            }
        }
    }
    
    // when student/CP want to view office hour of another day
    @IBAction func selectDay(_ sender: UIBarButtonItem) {
        timer?.invalidate() // end repeated fetching while quiting the current view
        showCalendar()
    }
    
    @IBAction func BackToClasses(_ sender: UIBarButtonItem) {
        Helper.SwitchToClassesVC(currVC: self)
    }
    
    
    // function to update style of the day view
    func updateStyle() -> CalendarStyle {
        let selector = DaySelectorStyle()
        selector.activeTextColor = Global.cusDark
        selector.inactiveTextColor = Global.cusGrey
        selector.selectedBackgroundColor = Global.cusGreen
        selector.todayActiveBackgroundColor = Global.cusGreen
        selector.todayInactiveTextColor = Global.cusGreen
        
        let daySymbols = DaySymbolsStyle()
        daySymbols.weekDayColor = Global.cusDark
        daySymbols.weekendColor = Global.cusGrey
        
        let swipeLabel = SwipeLabelStyle()
        swipeLabel.textColor = Global.cusDark
        
        let header = DayHeaderStyle()
        header.daySelector = selector
        header.daySymbols = daySymbols
        header.swipeLabel = swipeLabel
        header.backgroundColor = Global.cusWhite
        
        let timeline = TimelineStyle()
        timeline.timeIndicator.color = UIColor.red
        timeline.lineColor = Global.cusGrey
        timeline.timeColor = Global.cusGrey
        timeline.backgroundColor = Global.cusWhite
        
        let style = CalendarStyle()
        style.header = header
        style.timeline = timeline
        
        return style
    }
    
    // every 5 seconds, check with google calendar server whether there is new events to add
    func backgroundListEvents() {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            // enter background mode
            var fetchScheduleTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            fetchScheduleTask = UIApplication.shared.beginBackgroundTask() {
                () -> Void in
                print("Time out: fetch schedule background task suspended")
                UIApplication.shared.endBackgroundTask(fetchScheduleTask)
                fetchScheduleTask = UIBackgroundTaskIdentifier.invalid
            }
            
            if let date = self.dayView.state?.selectedDate {
                self.appointmentModel.fetcheEvents(Global.calendarId, date) {
                    (success, error) in
                    if(success) {
                        DispatchQueue.main.async {
                            self.reloadData() // similar to .reloadData of tableView and collectionView
                        }
                    }
                }
            }
        }
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

extension ScheduleVC: WWCalendarTimeSelectorProtocol {
    func showCalendar() {
        let selector = WWCalendarTimeSelector.instantiate()
        if let currDate = self.dayView.state?.selectedDate {
            selector.optionCurrentDate = currDate
        }
        else {
            selector.optionCurrentDate = Date()
        }
        selector.delegate = self
        selector.optionButtonShowCancel = true
        selector.optionTopPanelBackgroundColor = Global.cusGreen
        selector.optionSelectorPanelBackgroundColor = Global.cusGreen
        selector.optionMainPanelBackgroundColor = Global.cusWhite
        selector.optionBottomPanelBackgroundColor = Global.cusWhite
        selector.optionCalendarBackgroundColorFutureDatesHighlight = Global.cusGreen
        selector.optionCalendarBackgroundColorTodayHighlight = Global.cusGreen
        selector.optionCalendarBackgroundColorPastDatesHighlight = Global.cusGreen
        selector.optionButtonFontColorCancel = Global.cusGreen
        selector.optionButtonFontColorDone = Global.cusGreen
        selector.optionSelectorPanelFontColorTimeHighlight = UIColor.white
        selector.optionClockBackgroundColorAMPMHighlight = Global.cusGreen
        selector.optionClockBackgroundColorHourHighlight = Global.cusGreen
        selector.optionClockBackgroundColorMinuteHighlight = Global.cusGreen
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(false)
        
        /*
         Any other options are to be set before presenting selector!
         */
        self.present(selector, animated: true, completion: nil)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Calendar.current.locale
        
        // CP/student choosing the day to view
        print("Normally selected \n\(formatter.string(from: date))\n---")        // if a CP is rescheduling
        self.dayView.state?.move(to: date)
        
    }
    
    func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date) {
        
    }
    
    func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector) {
        
    }
    

}
