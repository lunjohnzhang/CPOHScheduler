//
//  ServerAPIManager.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/15.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import Foundation
import AeroGearHttp
import AeroGearOAuth2
import OAuthSwift

class GoogleServerAPIManager: ManagerBase {
    static let sharedInstance = GoogleServerAPIManager()
    private let http = Http(baseURL: "https://www.googleapis.com")
    private let kClientID = "988226545183-p1nvl9ns86dsifp4hddfvdgp6qnsthdu.apps.googleusercontent.com"
    private let calendarScope = "https://www.googleapis.com/auth/calendar.events"
    private let accountId = "anything"
    
    override init() {
        // config the google user
        let googleConfig = GoogleConfig(
            clientId: kClientID,
            scopes:[calendarScope],
            accountId: accountId)
        let gdModule = AccountManager.addGoogleAccount(config: googleConfig)
        http.authzModule = gdModule
    }
    
    func listEvents(_ calendarId: String, _ reqDate: Date, withHandler callback: @escaping (_ success: Bool, _ events: NSArray?, _ error: AnyObject?) -> Void) {
        
        // set up the http request
        let formatter = Helper.getFormatter(format: "yyyy-MM-dd HH:mm")
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: reqDate)
        let year = calendarDate.year
        let month = calendarDate.month
        let day = calendarDate.day
        if let year = year, let month = month, let day = day {
            let start = formatter.date(from: "\(year)-\(month)-\(day) 00:00")!.iso8601
            let end = formatter.date(from: "\(year)-\(month)-\(day) 23:59")!.iso8601
            
            // parameters needed for google calendar list api
            let parameters: [String: Any] = ["orderBy": "startTime",
                                             "singleEvents": "true",
                                             "timeMin": start,
                                             "timeMax": end]
            
            // make the request
            // GET https://www.googleapis.com/calendar/v3/calendars/calendarId/events
            http.request(method: .get, path: "/calendar/v3/calendars/\(calendarId)/events", parameters: parameters) {
                (response, error) in
                if (error != nil) {
                    print("Error listing events: \(error!.localizedDescription)")
                    callback(false, nil, error)
                } else {
                    print("Successfully got events!")
                    let dic = response as! NSDictionary
                    let events = dic["items"] as! NSArray
                    callback(true, events, error)
                }
            }
        }
    }
    
    func deleteEvent(_ calendarId: String, _ eventId: String, withHandler callback: @escaping (_ success: Bool, _ error: AnyObject?) -> Void) {
        // DELETE https://www.googleapis.com/calendar/v3/calendars/calendarId/events/eventId
        http.request(method: .delete, path: "/calendar/v3/calendars/\(calendarId)/events/\(eventId)") {
            (response, error) in
            if(error != nil) {
                // the framework cannot recognize empty request, the deletion is actually successful if such error happens
                if(error!.localizedDescription == "Invalid response received, can't parse JSON") {
                    callback(true, error)
                }
                else {
                    print("Error deleting event: \(error!.localizedDescription)")
                    callback(false, error)
                }
            }
            else {
                print("Successfully deleted event!")
                callback(true, error)
            }
        }
    }
    
    func updateEvent(_ calendarId: String, changeTo event: EventWithId, withHandler callback: @escaping (_ success: Bool, _ error: AnyObject?) -> Void) {
        // set up the request body
        let startTime = event.startDate.iso8601
        let endTime = event.endDate.iso8601
        let parameter: [String: Any] = ["start": ["dateTime": startTime],
                                     "end": ["dateTime": endTime],
                                     "summary": event.summary as Any,
                                     "location": event.location as Any]
        // PUT https://www.googleapis.com/calendar/v3/calendars/calendarId/events/eventId
        if let id = event.Id {
            http.request(method: .put, path: "/calendar/v3/calendars/\(calendarId)/events/\(id)", parameters: parameter) {
                (response, error) in
                if(error != nil) {
                    print("Error Updating events: \(String(describing: error?.description))")
                    callback(false, error)
                }
                else {
                    print("Successfully updated event!")
                    callback(true, error)
                }
            }
        }
        else {
            print("Google server manager: unable to obtain event Id")
        }
    }
    
    func getProfileImage(_ url: URL, withHandler callback: @escaping (_ success: Bool, _ data: Data?, _ error: Error?) -> Void) {
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if (error != nil) {
                print("Error getting profile image")
                callback(false, nil, error)
            }
            else {
                print("Successfully get profile image")
                callback(true, data, error)
            }
        }
        task.resume()
    }
}
