//
//  MeVC.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/21.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import UIKit
import GoogleSignIn

class MeVC: UIViewController {
    // sharedInstances
    let getManager = GetManager.sharedInstance
    
    // IBOutlets
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.layer.cornerRadius = signOutButton.frame.width * 0.03
        nameLabel.text = Global.userName
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.image = UIImage(named: "defaultProfile")
        
        
        // get profile pic
        if let url = Global.userProfileURL {
            getManager.getProfilePic(url) {
                (success, data, error) in
                if(success) {
                    DispatchQueue.main.async {
                        if let data = data {
                            let image = UIImage(data: data)
                            self.profilePic.image = image
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        Helper.SwitchToSignInVC(currVC: self)
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
