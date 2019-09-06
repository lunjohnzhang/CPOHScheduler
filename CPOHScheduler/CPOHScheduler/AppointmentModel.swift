//
//  AppointmentModel.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/15.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation

class AppointmentModel {
    let getManager = GetManager.sharedInstance
    let deleteManager = DeleteManager.sharedInstance
    let putManager = PutManager.sharedInstance
    
    static let sharedInstance = AppointmentModel()
    var appointments: [Appointment]?
    
    init() {
        appointments = []
    }
    
    func fetcheEvents(_ calendarId: String, _ reqDate: Date, withHandler callback: @escaping (_ success: Bool, _ error: AnyObject?) -> Void) {
        getManager.listEvents("primary", reqDate) {
            (success, events, error) in
            if(success) {
                // clean up the data model since we only need events of the current date
                if let _ = self.appointments {
                    self.appointments?.removeAll()
                }
                
                // receive the events and show them
                if let events = events {
                    for event in events {
                        let eventReal = event as! NSDictionary
                        if let summaryR = eventReal["summary"], let start = eventReal["start"], let end = eventReal["end"], let IdR = eventReal["id"] {
                            let startDic = start as! NSDictionary
                            let endDic = end as! NSDictionary
                            let summary = summaryR as! String
                            let Id = IdR as! String
                            if let startDateTime = startDic["dateTime"], let endDateTime = endDic["dateTime"] {
//                                print("summary: \(summary)")
//                                print("start: \(startDateTime)")
//                                print("Id: \(Id)")
                                let formatter = Helper.getFormatter(format: "yyyy-MM-dd'T'HH:mm:ss-07:00")
                                let startTime = formatter.date(from: startDateTime as! String)
                                let endTime = formatter.date(from: endDateTime as! String)
                                if let start = startTime, let end = endTime {
                                    let newAppointment = Appointment(start: start, end: end, title: summary, Id: Id)
                                    if let locationR = eventReal["location"] {
                                        let location = locationR as! String
                                        newAppointment.location = location
//                                        print("location: \(location)")
                                    }
                                    self.appointments?.append(newAppointment)
//                                    print()
                                }
                            }
                        }
                    }
                }
                else {
                    print("No events found")
                }
                callback(true, error)
            }
            else {
                callback(false, error)
            }
        }
    }
    
    func deleteEvent(_ calendarId: String, _ eventId: String, withHandler callback: @escaping (_ success: Bool, _ error: AnyObject?) -> Void) {
        deleteManager.deleteEvent(calendarId, eventId) {
            (success, error) in
            if(success) {
                callback(true, error)
            }
            else{
                callback(false, error)
            }
        }
    }
    
    func updateEvent(_ calendarId: String, changeTo event: EventWithId, withHandler callback: @escaping (_ success: Bool, _ error: AnyObject?) -> Void) {
        putManager.updateEvent(calendarId, changeTo: event) {
            (success, error) in
            if(success) {
                callback(true, error)
            }
            else{
                callback(false, error)
            }
        }
    }
}
