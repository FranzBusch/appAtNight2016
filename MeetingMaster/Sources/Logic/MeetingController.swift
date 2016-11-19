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
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.tick)
            EventBus<MeetingUpdatedEvent>.post(MeetingUpdatedEvent())
        }
    }

    func tick(_ timer: Timer) {
        currentMeeting?.participants.forEach { participant in
            participant.eta = max(participant.eta - 1, 0)
        }

        EventBus<MeetingUpdatedEvent>.post(MeetingUpdatedEvent())

//        if !(currentMeeting?.participants.contains { $0.eta != 0 } ?? true) {
//            timer.invalidate()
//        }
    }

}
