//
//  Dairy.swift
//  Sleep Learning
//
//  Created by Mani Jahani on 6/20/19.
//  Copyright © 2019 Memory Lab. All rights reserved.
//
//  Description:
//      The Diary class defines the fields in the diary and also handles
//      uploading the diary to the server.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Diary {
    var diaryData: [String: Any]
    var diaryDate: String
    var diaryDateTime: String
    var diarydayNum: Int
    var changedDay: Bool 
    
    init() {
        diaryData = [String: Any]()
        // Initialize the values
        diaryData["timeWhenStart"] = nil
        diaryData["timeWhenEnd"] = nil
        diaryData["volumes"] = [Float]()
        diaryData["timesRecordVolume"] = [Date]()
        diaryData["numberOfPauses"] = 0
        diaryData["timesPressedPause"] = [Date]()
        diaryData["timesPressedContinue"] = [Date]()
        diaryData["streamMinsReported"] = nil
        diaryData["activity"] = nil
        //diaryData["interruptYN"] = nil
        diaryData["englishHeardYN"] = nil
        diaryData["numPhrases"] = nil
        diaryData["englishPhrase1"] = nil
        diaryData["englishPhrase2"] = nil
        diaryData["englishPhrase3"] = nil
        diaryData["englishSpeaker1"] = nil
        diaryData["englishSpeaker2"] = nil
        diaryData["englishSpeaker3"] = nil
        diaryData["issuesWithVolumeYN"] = nil
        diaryData["issuesWithVolume"] = nil
        diaryData["issuesWithAppYN"] = nil
        diaryData["issuesWithApp"] = nil
        diaryData["audioFile"] = nil
        diaryData["timeForSession"] = 0.0
        diaryData["totalTimeForDay"] = 0.0
        diaryDate = ""
        diaryDateTime = ""
        diarydayNum = 1
        changedDay = true
        //diaryDate = ""
//        diaryData["numberOfRestarts"] = 0
//        diaryData["timesPressedRestart"] = [Date]()
//        diaryData["heardInitialWarningSounds"] = nil
//        diaryData["pressedRestart"] = nil
//        diaryData["awakenedBySoundsOrLanguage"] = nil
//        diaryData["numberOfTimesWokenUp"] = nil
//        diaryData["languageHeardAfterWaking"] = nil
//        diaryData["notAwakenedButHeardALanguage"] = nil
//        diaryData["languageHeardWhileAsleep"] = nil
//        diaryData["headphonesStayedIn"] = nil
//        diaryData["phoneLocation"] = nil
    }
    
    mutating func resetInfo(resetDay : Bool){
        //reset diary data
        diaryData["timeWhenStart"] = nil
        diaryData["timeWhenEnd"] = nil
        diaryData["volumes"] = [Float]()
        diaryData["timesRecordVolume"] = [Date]()
        diaryData["numberOfPauses"] = 0
        diaryData["timesPressedPause"] = [Date]()
        diaryData["timesPressedContinue"] = [Date]()
        diaryData["streamMinsReported"] = nil
        diaryData["activity"] = nil
        diaryData["englishHeardYN"] = nil
        diaryData["numPhrases"] = nil
        diaryData["englishPhrase1"] = nil
        diaryData["englishPhrase2"] = nil
        diaryData["englishPhrase3"] = nil
        diaryData["englishSpeaker1"] = nil
        diaryData["englishSpeaker2"] = nil
        diaryData["englishSpeaker3"] = nil
        diaryData["issuesWithVolumeYN"] = nil
        diaryData["issuesWithVolume"] = nil
        diaryData["issuesWithAppYN"] = nil
        diaryData["issuesWithApp"] = nil
        diaryData["timeForSession"] = 0.0
        if (resetDay){
            diaryData["totalTimeForDay"] = 0.0
        }
    }
    
    //  Helper function that returns the date as a string -- to be used as the
    //  diary document title with format: Aug 1, 2019 at 5:40 PM
    internal func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
        
        let todaysDate = Date()
        
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: todaysDate)
    }
    
    internal func getDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let todaysDate = Date()
        
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: todaysDate)
    }
    
    // Uploads all the filled out fields in the diary to the server
    func upload() {
        let Database = Firestore.firestore()
        
        //  Use the date as title for the diary document
        //let todaysDate = getDate()
        
        //  Get user ID, add data to the appropriate collection corresponding to the user ID
        //  User ID can be found in "Subjects -> [UserEmail] -> ID"
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("No User Email")
            return
        }
        let userInfoDocRef = Database.collection("Subjects").document(userEmail)
        userInfoDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //  Find user ID
                let userID = (document.data()!["ID"] as! String)
                let collectionName = "Day " + String(diary.diarydayNum)
                //  Store diary data in the collection titled with the user ID in a document with the day number as the title
                let collection1 = Database.collection(userID).document(self.diaryDate).collection(collectionName);
                collection1.document(self.diaryDateTime).setData(self.diaryData) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added")
                    }
                }
            }
            else {
                print("User document does not exist")
            }
        }
    }
}

var diary = Diary()
