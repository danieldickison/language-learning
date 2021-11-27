//
//  Session.swift
//  Sleep Learning
//
//  Created by Mani Jahani on 6/10/19.
//  Copyright © 2019 Memory Lab. All rights reserved.
//
//  Description:
//      The Session class handles beginning, restarting, and ending a session.
//

import Foundation
import Firebase
import FirebaseFirestore

class Session {
    // is the participant asleep
    var sessionRunning = false
    var sessionPaused = false
    //var timeSession = 0
    
//    func getTimeInterval(time2 : Date) -> TimeInterval{
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.minute]
//        let time1 = diary.diaryData["timeWhenAsleep"]
//        //let time2 = Date()
//        let timeint = time2.timeIntervalSince(time1 as! Date)
//        //print(time1, time2, timeint)
//        return timeint
      //getTimeInterval(time2 : diary.diaryData["timeWhenAwake"] as! Date)
//    }
    
    func beginSession() {
        sessionRunning = true
        diary.diaryDate = diary.getDate()
        diary.diaryDateTime = diary.getDateTime()
        
        //reset diary data
        diary.diaryData["timeWhenAsleep"] = nil
        diary.diaryData["timeWhenAwake"] = nil
        diary.diaryData["volumes"] = [Float]()
        diary.diaryData["timesRecordVolume"] = [Date]()
        diary.diaryData["numberOfPauses"] = 0
        diary.diaryData["timesPressedPause"] = [Date]()
        diary.diaryData["timesPressedContinue"] = [Date]()
        diary.diaryData["streamMinsReported"] = 0
        diary.diaryData["activity"] = nil
        diary.diaryData["englishHeardYN"] = nil
        diary.diaryData["numPhrases"] = 0
        diary.diaryData["englishPhrase1"] = nil
        diary.diaryData["englishPhrase2"] = nil
        diary.diaryData["englishPhrase3"] = nil
        diary.diaryData["englishSpeaker1"] = nil
        diary.diaryData["englishSpeaker2"] = nil
        diary.diaryData["englishSpeaker3"] = nil
        diary.diaryData["issuesWithVolumeYN"] = nil
        diary.diaryData["issuesWithVolume"] = nil
        diary.diaryData["issuesWithAppYN"] = nil
        diary.diaryData["issuesWithApp"] = nil
        diary.diaryData["audioFile"] = nil
        diary.diaryData["timeForSession"] = nil
        
        diary.diaryData["timeStart"] = Date()
        diary.upload()
        //  The first series of audio files are silent, so the audio is loaded and
        //  played immediately when the session begins
        audioPlayer.loadAudioToStartSession()
        audioPlayer.playAudio(recordVol: true)
    }
    
    func endSession() {
        audioPlayer.stopAudio(recordVol : true)
        sessionRunning = false
        let date1 = Date()
        diary.diaryData["timeEnd"] = date1
        diary.upload()
        
        // time for session
        var elapsed = date1.timeIntervalSince(diary.diaryData["timeWhenAsleep"] as! Date)
        elapsed = elapsed/60
        elapsed = round(elapsed * 100) / 100.0
        diary.diaryData["timeForSession"] = elapsed
        
        diary.upload()
    }
    
//    func restart() {
//        if audioPlayer.restartAudio() {
//            // Because diaryData has the type [String: Any], in order to manipulate the value
//            // they have to be cast to their correct type
//            diary.diaryData["numberOfRestarts"] = diary.diaryData["numberOfRestarts"] as! Int + 1
//            diary.diaryData["timesPressedRestart"] = (diary.diaryData["timesPressedRestart"] as! [Date]) + [Date()]
//            diary.upload()
//        }
//    }
    
    func continuePlay() {
        audioPlayer.playAudio(recordVol: true)
        // Because diaryData has the type [String: Any], in order to manipulate the value
        // they have to be cast to their correct type
        diary.diaryData["timesPressedContinue"] = (diary.diaryData["timesPressedContinue"] as! [Date]) + [Date()]
        sessionPaused = false
        diary.upload()
    }
    
    func pause() {
        audioPlayer.pauseAudio(recordVol: true)
        sessionPaused = true
        // Because diaryData has the type [String: Any], in order to manipulate the value
        // they have to be cast to their correct type
        diary.diaryData["numberOfPauses"] = diary.diaryData["numberOfPauses"] as! Int + 1
        diary.diaryData["timesPressedPause"] = (diary.diaryData["timesPressedPause"] as! [Date]) + [Date()]
        diary.upload()
    }
}
