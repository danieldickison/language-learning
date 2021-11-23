//
//  SessionCompletedViewController.swift
//  Sleep Learning
//
//  Created by Mani Jahani on 7/3/19.
//  Copyright © 2019 Memory Lab. All rights reserved.
//
//  Description:
//      This is the view controller for the final page of the app. It allows
//      the user to log out if they wish to.
//

import UIKit
import Firebase

class SessionCompletedViewController: UIViewController {
    
    //  Set the status bar to have light content so it's visible against the black
    //  background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changeText(bodyText)
        diary.upload()
    }
    
    var confirmedLogOut = false
    
    @IBOutlet weak var bodyText: UILabel!

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        bodyText.delegate = self //Without setting the delegate you won't be able to track UITextView events
//    }
//
//    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
//        print(textView.text); //the textView parameter is the textView where text was changed
//    }
    
    func changeText(_ textView: UILabel){
        let num = Int(diary.diaryData["timeForSession"] as! Double)
        //num = Int(num)
        textView.text = String(num)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        //  Display confirmation alert
        let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to log out. You will need to log back in to use the app again.", preferredStyle: .alert)
        
        //  If yes, log out and segue back to log in page
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            // Log out
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.confirmedLogOut = true
                self.performSegue(withIdentifier: "logOutSegue", sender: sender)
            } catch let signOutError as NSError {
                //  If there's an error display it as an alert
                let errorAlert = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
        })
            
        //  If no, do nothing
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)

        confirmAlert.addAction(noButton)
        confirmAlert.addAction(yesButton)
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "logOutSegue" && self.confirmedLogOut == true {
            return true
        }
        return false
    }
    
}
