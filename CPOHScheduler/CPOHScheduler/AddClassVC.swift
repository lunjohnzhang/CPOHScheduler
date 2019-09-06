//
//  AddClassVC.swift
//  CPOHScheduler
//
//  Created by LunJohnZhang on 2019/4/25.
//  Copyright © 2019 Yulun Zhang. All rights reserved.
//

import UIKit

class AddClassVC: UIViewController, UITextFieldDelegate {

    // sharedInstances
    let instructorModel = InstructorModel.sharedInstance
    let classModel = ClassModel.sharedInstance
    let getManager = GetManager.sharedInstance
    
    // IBOutlets
    @IBOutlet weak var classIdTF: UITextField!
    @IBOutlet weak var classNameTF: UITextField!
    @IBOutlet weak var classTermTF: UITextField!
    @IBOutlet weak var instructorNameTF: UITextField!
    @IBOutlet weak var instructorEmailIdTF: UITextField!
    
    @IBOutlet weak var instructorsTableView: UITableView!
    @IBOutlet weak var addInstructorButton: UIButton!
    
    // other variables
    let kReuseIdentifier = "InstructorCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        addInstructorButton.layer.cornerRadius = 0.5
        addInstructorButton.alpha = 0.5
        addInstructorButton.isEnabled = false
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        // add new class to database
        if let className = classNameTF.text, let classId = classIdTF.text, let classTerm = classTermTF.text, let instructors = instructorModel.instructors, instructors.count > 0 {
            classModel.classes?.append(Class(classId, className, classTerm, instructors))
            getManager.saveClass("USC")
            self.instructorModel.instructors?.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
        else {
            // if something is missing, show an alert
            let alertController = UIAlertController(title: "Alert", message: "Please fill in all required fields!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addInstructor(_ sender: Any) {
        let insName = instructorNameTF.text
        let insId = instructorEmailIdTF.text
        if let name = insName, let id = insId {
            instructorModel.addInstructor(name, id)
            instructorsTableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if classIdTF.isFirstResponder {
            classIdTF.resignFirstResponder()
            classNameTF.becomeFirstResponder()
        }
        else if classNameTF.isFirstResponder {
            classNameTF.resignFirstResponder()
            classTermTF.becomeFirstResponder()
        }
        else if classTermTF.isFirstResponder {
            classTermTF.resignFirstResponder()
            instructorNameTF.becomeFirstResponder()
        }
        else if instructorNameTF.isFirstResponder {
            instructorNameTF.resignFirstResponder()
            instructorEmailIdTF.becomeFirstResponder()
        }
        else if instructorEmailIdTF.isFirstResponder {
            instructorEmailIdTF.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let insName = instructorNameTF.text
        let insId = instructorEmailIdTF.text
        if instructorNameTF.isFirstResponder {
            if let insName = insName, let insId = insId, let updatedInsName = changeChar(toChange: insName, shouldChangeCharactersIn: range, replacementString: string) {
                enableAddButton(updatedInsName, insId)
            }
        }
        else if instructorEmailIdTF.isFirstResponder {
            if let insName = insName, let insId = insId, let updatedInsId = changeChar(toChange: insId, shouldChangeCharactersIn: range, replacementString: string) {
                enableAddButton(insName, updatedInsId)
            }
        }
        return true
    }
    
    func changeChar(toChange: String, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> String? {
        var updatedAnswer: String!
        if let range = Range(range, in: toChange) {
            updatedAnswer = toChange.replacingCharacters(in: range, with: string)
        }
        return updatedAnswer
    }
    
    func enableAddButton(_ insName: String, _ InsId: String) {
        if insName.count > 0 && InsId.count > 0 {
            addInstructorButton.alpha = 0.95
            addInstructorButton.isEnabled = true
        }
        else {
            addInstructorButton.alpha = 0.5
            addInstructorButton.isEnabled = false
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

extension AddClassVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let instructors = instructorModel.instructors {
            return instructors.count
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseIdentifier)
        if let instructors = instructorModel.instructors {
            cell?.textLabel?.text = instructors[indexPath.row].name
            cell?.detailTextLabel?.text = instructors[indexPath.row].emailId
        }
        return cell!
    }
    
}
