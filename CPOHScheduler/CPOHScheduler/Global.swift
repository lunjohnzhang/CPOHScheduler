//
//  Global.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/18.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation
import UIKit

// stores all global variables
class Global {
    // fixed calendar for testing
    static let calendarId = "primary"
    
    // color constants
    static let cusDark = UIColor(rgb: 0x222831)
    static let cusGrey = UIColor(rgb: 0x393e46)
    static let cusGreen = UIColor(rgb: 0x00adb5)
    static let cusWhite = UIColor(rgb: 0xeeeeee)
    
    // store user information
    static var userEmailId: String?
    static var userName: String?
    static var userProfileURL: URL?
    
}
