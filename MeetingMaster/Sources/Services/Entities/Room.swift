//
//  Room.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Gloss

class Room: Decodable {

    let numberOfPlaces: Int

    required init?(json: JSON) {
        guard let numberOfPlaces: Int = "numplaces" <~~ json else {
            return nil
        }

        self.numberOfPlaces = numberOfPlaces
    }

}
