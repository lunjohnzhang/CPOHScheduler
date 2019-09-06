//
//  InstructorModel.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/25.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation

class InstructorModel {
    static let sharedInstance = InstructorModel()
    var instructors: [Instructor]?
    
    init() {
        instructors = []
    }
    
    func addInstructor(_ name: String, _ emailId: String) {
        if instructors == nil{
            instructors = []
        }
        instructors?.append(Instructor(name, emailId))
    }
}
