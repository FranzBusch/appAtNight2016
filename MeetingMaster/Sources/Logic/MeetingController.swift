//
//  MeetingController.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Foundation

class MeetingController {


    static let sharedInstance = MeetingController()

    var currentMeeting: Meeting?

    private var timer = Timer()

    private init() {

    }

    func updateMeeting() {
        MMBaseService.fetchMeeting { result in
            guard let meeting = result.value else { return }

            self.currentMeeting = meeting
            self.timer = Timer(timeInterval: 1 ,
                                 target: self,
                                 selector: #selector(self.tick),
                                 userInfo: nil,
                                 repeats: true)

            RunLoop.main.add(self.timer, forMode: .commonModes)
            EventBus<MeetingUpdatedEvent>.post(MeetingUpdatedEvent())
        }
    }

    @objc func tick(_ timer: Timer) {
        currentMeeting?.participants.forEach { participant in
            if participant.status == .accepted {
                participant.eta = max(participant.eta - 1, 0)
            }
        }

        EventBus<MeetingUpdatedEvent>.post(MeetingUpdatedEvent())

        if !(currentMeeting?.participants.contains { $0.eta != 0 && $0.status == .accepted } ?? true) {
            timer.invalidate()
            EventBus<MeetingBeganEvent>.post(MeetingBeganEvent())
        }

    }

}
