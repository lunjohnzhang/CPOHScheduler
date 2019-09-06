//
//  NaviToScheduleVC.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/16.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import UIKit

class NaviToScheduleVC: UINavigationController{

    var isStudent = false
    var classChosen: Class?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        let scheduleVC = segue.destination as! ScheduleVC
//        scheduleVC.isStudent = isStudent
    }
}
