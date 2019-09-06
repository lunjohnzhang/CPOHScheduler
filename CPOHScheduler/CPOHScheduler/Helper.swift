//
//  Helper.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/15.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static func SwitchToScheduleVC(classChosen: Class, isStudent: Bool, currVC: UIViewController) {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate the map view
        let naviVC = storyboard.instantiateViewController(withIdentifier: "naviToScheduleVC") as! NaviToScheduleVC
        naviVC.isStudent = isStudent
        naviVC.classChosen = classChosen
        naviVC.modalTransitionStyle = .coverVertical
        
        // set the navigation view controller as root view
        currVC.present(naviVC, animated: true, completion: nil)
    }
    
    static func SwitchToRescheduleVC(event: EventWithId, currVC: UIViewController) {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate the map view
        let rescheduleVC = storyboard.instantiateViewController(withIdentifier: "RescheduleVC") as! RescheduleVC
        rescheduleVC.eventToChange = event
        rescheduleVC.modalTransitionStyle = .coverVertical
        
        // set the navigation view controller as root view
        currVC.present(rescheduleVC, animated: true, completion: nil)
    }
    
    static func SwitchToClassesVC(currVC: UIViewController) {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate the map view
        let classesVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
        
        classesVC.modalTransitionStyle = .coverVertical
        
        // set the navigation view controller as root view
        currVC.present(classesVC, animated: true, completion: nil)
    }
    
    static func SwitchToSignInVC(currVC: UIViewController) {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate the map view
        let classesVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        
        classesVC.modalTransitionStyle = .coverVertical
        
        // set the navigation view controller as root view
        currVC.present(classesVC, animated: true, completion: nil)
    }
    
    static func SwitchToAddClassVC(currVC: UIViewController) {
        // create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate the map view
        let classesVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        
        classesVC.modalTransitionStyle = .coverVertical
        
        // set the navigation view controller as root view
        currVC.present(classesVC, animated: true, completion: nil)
    }
    
    
    static func getFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        return formatter
    }
    
    
    static func convertDataToString(_ inputData : Data) -> NSString?{
        
        let returnString = String(data: inputData, encoding: String.Encoding.utf8)
        //print(returnString)
        return returnString as NSString?
        
    }
    
    
    static func convertDictionaryToJsonData(_ inputDict : Dictionary<String, AnyObject>) -> Data?{
        
        do{
            return try JSONSerialization.data(withJSONObject: inputDict, options:JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error as NSError{
            print(error)
            
        }
        
        return nil
    }
    
    
    static func convertJsonDataToDictionary(_ inputData : Data) -> [String:AnyObject]? {
        guard inputData.count > 1 else{ return nil }  // avoid processing empty responses
        
        do {
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Dictionary<String, AnyObject>
        }catch let error as NSError{
            print(error)
            
        }
        return nil
    }
    
    static func convertJsonStringToDictionary(_ text: String) -> Array<Dictionary<String, AnyObject>>? {
        
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Array<Dictionary<String, AnyObject>>
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    static func getAjacentDateByDay(date: Date, by day: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: day, to: date)
    }
    
    static func getAjacentDateByMinute(date: Date, by minute: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minute, to: date)
    }
    
}
