//
//  DuringViewController.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class DuringViewController: UIViewController, AVAudioRecorderDelegate {
       @IBAction func recordButtonClicked(_ sender: UIButton) {
        print("Audio record")
        audioRecorder?.record()
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: "stopRecording", userInfo: nil, repeats: false)

        
    
    }
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.wav")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
    }
    func stopRecording(){
        audioRecorder?.stop()
        print("Audio stopped")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:
                (audioRecorder?.url)!)
            //audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }
}
