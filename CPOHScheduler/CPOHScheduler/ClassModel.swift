//
//  ClassModel.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/21.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ClassModel {
    static let sharedInstance = ClassModel()
    var ref: DatabaseReference!
    var databaseHandler: DatabaseHandle?
    var classes: [Class]?
    
    init() {
        //fetch data from database
        classes = []
    }
    
    func fetchClasses(_ school: String, withHandler callback: @escaping (_ success: Bool) -> Void) {
        ref = Database.database().reference()
        _ = ref?.child("Classes").child(school).observeSingleEvent(of: .value) {
            (snapshot) in
            if snapshot.exists(){
                self.classes?.removeAll()
                let classes = snapshot.value as? [String : AnyObject] ?? [:]
                for oneClass in classes {
                    let detail = oneClass.value as! NSDictionary
                    let id = detail["Id"] as? String ?? ""
                    let name = detail["Name"] as? String ?? ""
                    let term = detail["Term"] as? String ?? ""
                    let instructors = detail["Instructors"] as? NSDictionary ?? [:]
                    let newClass = Class(id, name, term, instructors)
                    self.classes?.append(newClass)
                }
                self.classes = self.classes?.sorted() {
                    Class1, Class2 in
                    return Class1.classId < Class2.classId
                }
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    func creatClass(_ school: String, _ class: Class) {
        
    }
}
