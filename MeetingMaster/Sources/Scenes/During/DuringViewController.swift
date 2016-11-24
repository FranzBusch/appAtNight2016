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
import SpeechToTextV1

class DuringViewController: UIViewController, AVAudioRecorderDelegate {



    @IBOutlet var timeBar: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timetrailing: NSLayoutConstraint!

    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var temperatureTraillingConstraint: NSLayoutConstraint!
    @IBOutlet var temperatureBar: UIView!

    @IBOutlet var co2Label: UILabel!
    @IBOutlet var co2TraillingConstraint: NSLayoutConstraint!

    @IBOutlet var noiselabel: UILabel!
    @IBOutlet var noiseTraillingConstraint: NSLayoutConstraint!
    
    @IBOutlet var protocolLabel: UIVerticalAlignLabel!
    @IBOutlet var noiseBar: UIView!

    @IBOutlet var putinView: ParticipantImageView!
    @IBOutlet var merkelview: ParticipantImageView!
    var isRecording = false

    let username = "312ac6a4-b8f4-42e2-9783-cb1af9a5238e"
    let password = "3DkhfEF4ENsq"

    var speechToText: SpeechToText!

    var loud = false

    var time: TimeInterval = 60*20

    override func viewDidLoad() {
        super.viewDidLoad()
AVAudioSession.sharedInstance().requestRecordPermission { _ in
    
        }
        merkelview.state = .orange
        putinView.state = .orange

        protocolLabel.verticalAlignment = .Top
        updateValues()
        barTick(self)
        speechToText = SpeechToText(username: username, password: password)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateValues), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(barTick), userInfo: nil, repeats: true)
    }

    @IBAction func cheat(_ sender: Any) {
        loud = !loud
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showAlert), userInfo: nil, repeats: false)
    }

    @IBAction func barTick(_ sender: Any) {
        time -= 1
        timeLabel.text = time.asStringHHmmss
        timetrailing.constant += 1
    }

    override var prefersStatusBarHidden: Bool {
        return true
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
        let alert = UIAlertController(title: "Take a break!", message: "It is getting really noisy in here. How about taking a break?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.loud = false
        }))
        alert.show()
    }


    @IBAction func recordButtonClicked(_ sender: UIButton) {

        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = true
        settings.interimResults = true
        let failure = { (error: Error) in print(error) }
        if !isRecording {
            isRecording = true
            speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
                self.protocolLabel.text = results.bestTranscript
            }
        } else {
            speechToText.stopRecognizeMicrophone()
            isRecording = false
        }
    }
}
