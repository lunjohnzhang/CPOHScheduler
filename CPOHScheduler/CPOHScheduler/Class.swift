//
//  Class.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/21.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation

class Class {
    var classId: String
    var className: String
    var schoolTerm: String
    var instructors = [Instructor]()
    
    init(_ classId: String, _ className: String, _ schoolTerm: String, _ instructors: NSDictionary) {
        self.classId = classId
        self.className = className
        self.schoolTerm = schoolTerm
        
        for instructor in instructors {
            let name = instructor.value as! String
            let id = instructor.key as! String
            self.instructors.append(Instructor(name, id))
        }
    }
    
    init(_ classId: String, _ className: String, _ schoolTerm: String, _ instructors: [Instructor]) {
        self.classId = classId
        self.className = className
        self.schoolTerm = schoolTerm
        self.instructors = instructors
    }
}
