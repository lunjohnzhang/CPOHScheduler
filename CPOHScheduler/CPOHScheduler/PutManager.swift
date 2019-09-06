//
//  PostManager.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/15.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation

class PutManager: ManagerBase {
    static let sharedInstance = PutManager()
    let googleServerAPIManager = GoogleServerAPIManager()
    
    func updateEvent(_ calendarId: String, changeTo event: EventWithId, withHandler callback: @escaping (_ success: Bool, _ error: AnyObject?) -> Void ) {
        googleServerAPIManager.updateEvent(calendarId, changeTo: event) {
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
