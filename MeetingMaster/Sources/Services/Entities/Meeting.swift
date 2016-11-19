//
//  Meeting.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Gloss


class Meeting: Decodable {

    let participants: [Participant]
    let room: Room
    let name: String

    required init?(json: JSON) {
        guard let participants: [Participant] = "participants" <~~ json,
            let room: Room = "room" <~~ json,
            let name:String = "name" <~~ json else {
            return nil
        }

        self.participants = participants
        self.room = room
        self.name = name
    }

    var presentParticipants: [Participant] {
        return participants.filter { $0.eta == 0 }
    }

    var travellingParticipants: [Participant] {
        return participants.filter { $0.eta != 0 }
    }

}
