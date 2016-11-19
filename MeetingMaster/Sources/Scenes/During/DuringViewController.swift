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


    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var temperatureTraillingConstraint: NSLayoutConstraint!
    @IBOutlet var temperatureBar: UIView!

    @IBOutlet var co2Label: UILabel!
    @IBOutlet var co2TraillingConstraint: NSLayoutConstraint!

    @IBOutlet var noiselabel: UILabel!
    @IBOutlet var noiseTraillingConstraint: NSLayoutConstraint!
    
    @IBOutlet var noiseBar: UIView!

    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    var loud = false

    override func viewDidLoad() {
        super.viewDidLoad()

        updateValues()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateValues), userInfo: nil, repeats: true)
    }

    @IBAction func cheat(_ sender: Any) {
        loud = !loud
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showAlert), userInfo: nil, repeats: false)
    }

    func updateValues() {
        let temp = Int(arc4random_uniform(2) + 24)
        let co2 = Int(arc4random_uniform(30) + 440)
        let noise = loud ? Int(arc4random_uniform(5) + 42) : Int(arc4random_uniform(5) + 28)

        noiseBar.backgroundColor = loud ? #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1) : #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)

        temperatureLabel.text = "\(temp)°"
        co2Label.text = "\(co2)ppm"
        noiselabel.text = "\(noise)db"

        temperatureTraillingConstraint.constant = CGFloat(160-temp)
        co2TraillingConstraint.constant = CGFloat(200 - co2/100)
        noiseTraillingConstraint.constant = CGFloat(300-3*noise)
    }

    func showAlert() {
        let alert = UIAlertController(title: "High noise values!", message: "It is getting really noisy in here. How about taking a break?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.loud = false
        }))
        alert.show()
    }


    @IBAction func recordButtonClicked(_ sender: UIButton) {
        let fileMgr = FileManager.default

        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)

        let soundFileURL = dirPaths[0].appendingPathComponent("sound")

        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
             AVNumberOfChannelsKey: 1,
             AVFormatIDKey: kAudioFormatLinearPCM,
             AVSampleRateKey: 12000] as [String : Any]

        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }

        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        print("Audio record")
        audioRecorder?.record()
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(stopRecording), userInfo: nil, repeats: false)
    }

    func stopRecording() {
        audioRecorder?.stop()
        print("Audio stopped")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
            MMBaseService.uploadWav()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }
}
