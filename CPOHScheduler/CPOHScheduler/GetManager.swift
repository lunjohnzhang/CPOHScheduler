//
//  GetManager.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/15.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GetManager: ManagerBase {
    static let sharedInstance = GetManager()
    let googleServerAPIManager = GoogleServerAPIManager.sharedInstance
    let classModel = ClassModel.sharedInstance
    
    func listEvents(_ calendarId: String, _ reqDate: Date, withHandler callback: @escaping (_ success: Bool, _ events: NSArray?, _ error: AnyObject?) -> Void ) {
        googleServerAPIManager.listEvents(calendarId, reqDate) {
            (success, events, error) in
            if(success) {
                callback(true, events, error)
            }
            else {
                callback(false, events, error)
            }
        }
    }
    
    func getProfilePic(_ url: URL, withHandler callback: @escaping (_ success: Bool, _ data: Data?, _ error: Error?) -> Void) {
        googleServerAPIManager.getProfileImage(url) {
            (success, data, error) in
            if(success) {
                callback(true, data, error)
            }
            else {
                callback(false, nil, error)
            }
        }
    }

    
    func isStudent(_ schoolId: String, _ classId: String, _ user: String, withHandler callback: @escaping (_ isStudent: Bool) -> Void){
        let ref = Database.database().reference()
        _ = ref.child("Classes").child(schoolId).child(classId).child("Instructors").child(user).observeSingleEvent(of: .value) {
            (snapshot) in
            // current user is not a student of the specified class
            if snapshot.exists(){
                callback(false)
            }
                
            // current user is a student of the specified class
            else {
                callback(true)
            }
        }
    }
    
    // loop through all classes in database, check whether the current user is an instructor
    func allowAddClass(_ schoolId: String, _ user: String, withHandler callback: @escaping (_ allowAdd: Bool) -> Void) {
        let ref = Database.database().reference()
        _ = ref.child("Classes").child(schoolId).observeSingleEvent(of: .value) {
            (snapshot) in
            let classes = snapshot.value as? NSDictionary
            if let classes = classes {
                for ClassRaw in classes {
                    let Class = ClassRaw.value as? NSDictionary
                    if let Class = Class {
                        let instructorRaw = Class.value(forKey: "Instructors") as? NSDictionary
                        if let instructors = instructorRaw {
                            for instructor in instructors {
                                let id = instructor.key as! String
                                if (id == user) {
                                    callback(true)
                                    return
                                }
                            }
                        }
                    }
                }
            }
            callback(false)
        }
    }
    
    func saveClass(_ schoolId: String) {
        let ref = Database.database().reference()
        // set up the class json
        var classesToAdd = [String: Any]()
        if let classes = classModel.classes {
            for oneClass in classes {
                var instructorsToAdd = [String: String]()
                for instructor in oneClass.instructors {
                    instructorsToAdd[instructor.emailId] = instructor.name
                }
                let classToAdd: [String: Any]
                              = ["Id": oneClass.classId,
                                  "Name": oneClass.className,
                                  "Term": oneClass.schoolTerm,
                                  "Instructors": instructorsToAdd
                                ]
                classesToAdd[oneClass.classId] = classToAdd
            }
            ref.child("Classes").child(schoolId).setValue(classesToAdd as NSDictionary)
        }
    }
}
