//
//  Participant.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Gloss

enum ParticipantStatus: String {
    case accepted = "Accepted"
    case declined = "Denied"
}

class Participant: Decodable {

    let name: String
    var eta: TimeInterval
    let job: String
    let status: ParticipantStatus

    required init?(json: JSON) {
        guard let name: String = "name" <~~ json,
            let eta: TimeInterval = "eta" <~~ json,
            let job: String = "jobtitle" <~~ json,
            let status: ParticipantStatus = "status" <~~ json else {
                return nil
        }

        self.name = name
        self.eta = eta
        self.job = job
        self.status = status
    }

}
