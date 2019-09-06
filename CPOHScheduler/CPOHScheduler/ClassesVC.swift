//
//  ViewController.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/13.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import UIKit
import GoogleSignIn
import AeroGearHttp
import AeroGearOAuth2

class ClassesVC: UIViewController {
    
    // sharedInstances
    let classModel = ClassModel.sharedInstance
    let getManager = GetManager.sharedInstance
    
    // other variables
    var isStudent = true
    let kReuseIdentifier = "classCell"
    var timer: Timer?
    
    // IBOutlets
    @IBOutlet var backView: UIView!
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        // fetch events every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
            timer in
            self.backgroundListClasss("USC")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get classes data
        classModel.fetchClasses("USC") {
            (success) in
            self.classCollectionView.reloadData()
        }
    }
    
    
    @IBAction func addClass(_ sender: UIBarButtonItem) {
        if let user = Global.userEmailId {
            getManager.allowAddClass("USC", user) {
                (allowAdd) in
                if(allowAdd) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toAddClassSegue", sender: self)
                    }
                }
                else {
                    self.showAlert()
                }
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Alert", message: "Sorry, students are not allowed to add classes", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
//    // prepare function
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "studentLogin", let scheduleVC = segue.destination as? ScheduleVC {
//            scheduleVC.isStudent = true
//        }
//    }

}

extension ClassesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.backView.layer.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        timer?.invalidate()
        if let user = Global.userEmailId, let classes = classModel.classes {
            getManager.isStudent("USC", classes[indexPath.row].classId, user) {
                (isStudent) in
                if isStudent {
                    Helper.SwitchToScheduleVC(classChosen: classes[indexPath.row], isStudent: true, currVC: self)
                }
                else {
                    Helper.SwitchToScheduleVC(classChosen: classes[indexPath.row], isStudent: false, currVC: self)
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let classes = classModel.classes {
            return classes.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseIdentifier, for: indexPath) as! ClassCVCell
        
        cell.classId.text = classModel.classes?[indexPath.row].classId
        cell.className.text = classModel.classes?[indexPath.row].className
        cell.schoolTerm.text = classModel.classes?[indexPath.row].schoolTerm
        cell.classId.textColor = Global.cusDark
        cell.className.textColor = Global.cusDark
        cell.schoolTerm.textColor = Global.cusDark
        cell.cellBackView.backgroundColor = Global.cusGreen
        cell.cellBackView.layer.cornerRadius = 0.03 * cell.cellBackView.bounds.size.width
        
//        if (indexPath.row != 0) {
//            cell.alpha = 0.5
//        }
        return cell
    }
    
    // every 10 seconds, check with google calendar server whether there is new events to add
    func backgroundListClasss(_ school: String) {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            // enter background mode
            var fetchClassesTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            fetchClassesTask = UIApplication.shared.beginBackgroundTask() {
                () -> Void in
                print("Time out: fetch classes background task suspended")
                UIApplication.shared.endBackgroundTask(fetchClassesTask)
                fetchClassesTask = UIBackgroundTaskIdentifier.invalid
            }
            
            self.classModel.fetchClasses(school) {
                (success) in
                if(success) {
                    DispatchQueue.main.async {
                        if(self.classCollectionView.numberOfItems(inSection: 0) != self.classModel.classes?.count) {
                            self.classCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
