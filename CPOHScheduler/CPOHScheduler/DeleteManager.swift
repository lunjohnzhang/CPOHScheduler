//
//  DeleteManager.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/18.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation

class DeleteManager: ManagerBase {
    static let sharedInstance = DeleteManager()
    let googleServerAPIManager = GoogleServerAPIManager.sharedInstance
    
    func deleteEvent(_ calendarId: String, _ eventId: String, withHandler callback: @escaping (_ success: Bool, _ error: AnyObject?) -> Void ) {
        googleServerAPIManager.deleteEvent(calendarId, eventId) {
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
