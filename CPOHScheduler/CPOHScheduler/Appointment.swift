//
//  Appointment.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/13.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation
import UIKit

// subclass DayScheduleViewAppointment
class Appointment {
    var color: UIColor
    var title: String
    var location: String?
    var startDate: Date
    var endDate: Date
    var isAllDay: Bool
    var Id: String
    
    init(start: Date, end: Date, title: String, Id: String, isAllDay: Bool = false, location: String? = "", color: UIColor = UIColor(rgb: 0x00adb5)) {
        self.startDate = start
        self.endDate = end
        self.isAllDay = isAllDay
        self.location = location
        self.color = color
        self.title = title
        self.Id = Id
    }
}
