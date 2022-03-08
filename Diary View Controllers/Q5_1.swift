//
//  Q5_1.swift
//  Sleep Learning
//
//  Created by Annie Xu on 9/27/21.
//  Copyright © 2021 Memory Lab. All rights reserved.
//

import UIKit
//import DropDown

class Q5_1: UIViewController {
    
    //  Set the status bar to have light content so it's visible against the black
    //  background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var responseField: UITextField!
    
    @IBOutlet weak var response2: DropDown!
    //response2.optionArray = ["Male", "Female"]
    @IBOutlet weak var response2Field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func continueToNextQuestion(_ sender: Any) {
        guard responseField.text != nil && responseField.text != "" && response2Field.text != nil && response2Field.text != "" else {
            return
        }
        diary.diaryData["englishPhrase1"] = responseField.text!
        diary.diaryData["englishPhraseGender1"] = response2Field.text!
        diary.upload()
    }

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "continueToNextQuestion" && (responseField.text == "" || responseField.text == nil) && (response2Field.text == "" || response2Field.text == nil) {
//            //  Display alert
//            let emptyAlert = UIAlertController(title: "Invalid response", message: "You must enter a response before continuing.", preferredStyle: .alert)
//            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(emptyAlert, animated: true, completion: nil)
//            return false
//        }
//        else {
//            return true
//        }
//    }

    @IBAction func unwindToPreviousQuestion(segue: UIStoryboardSegue) {
        return
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
