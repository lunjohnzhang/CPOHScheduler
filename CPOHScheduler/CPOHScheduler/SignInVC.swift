//
//  SignInVC.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/14.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import UIKit
import GoogleSignIn
import AVFoundation

class SignInVC: UIViewController {

    @IBOutlet weak var googleSignIn: GIDSignInButton!
    @IBOutlet weak var videoView: UIView!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Google Sign in staff
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "988226545183-p1nvl9ns86dsifp4hddfvdgp6qnsthdu.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = (self as GIDSignInDelegate)
        GIDSignIn.sharedInstance()?.scopes.append("https://www.googleapis.com/auth/calendar.events")
        
        self.playBackVideo()
        
    }
    
    // set up background video
    func playBackVideo() {
        let path = Bundle.main.path(forResource: "USC Campus Drone Tour", ofType: "mp4")
        if let path = path {
            player = AVPlayer(url: URL(fileURLWithPath: path))
            if let player = player {
                player.volume = 0
                
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = videoView.frame
                playerLayer.videoGravity = .resizeAspectFill
                
                videoView.layer.addSublayer(playerLayer)
                videoView.backgroundColor = .clear
                player.play()
                
                // set video to loop
                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem!)
            }
        }
        else {
            print("path not found")
        }
    }
    
    @objc func playerItemDidReachEnd() {
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInVC: GIDSignInDelegate, GIDSignInUIDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Sign in error: \(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            //                let userId = user.userID                  // For client-side use only!
            //                let idToken = user.authentication.idToken // Safe to send to the server
            
            let fullName = user.profile.name
            //                let givenName = user.profile.givenName
            //                let familyName = user.profile.familyName
            let email = user.profile.email
            let profileURL = user.profile.imageURL(withDimension: 100)
            
            // ...
            
            //                // needed for Oauth
            //                let accessToken = user.authentication.accessToken
            //                let refreshToken = user.authentication.refreshToken
            //                let accessTokenExp = user.authentication.accessTokenExpirationDate
            
            print("user \(fullName!) signed in")
            //                print("accessToken: \(accessToken!)")
            //                print("refreshToken: \(refreshToken!)")
            //                print("exp: \(accessTokenExp?.timeIntervalSince1970)")
            
            // store user information
            Global.userEmailId = String((email?.split(separator: "@")[0])!)
            Global.userProfileURL = profileURL
            Global.userName = fullName
            
            // switch to classesVC
            Helper.SwitchToClassesVC(currVC: self)
        }
    }
}
