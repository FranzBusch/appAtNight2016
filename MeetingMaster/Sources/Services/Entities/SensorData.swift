//
//  SensorData.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Gloss

class ParticipantSensorData: Decodable {

    let temp: Double
    let noise: Double
    let co2: Double
    let movement: Double

    required init?(json: JSON) {
        guard let temp: Double = "temp" <~~ json,
            let noise: Double = "noise" <~~ json,
            let co2: Double = "co2" <~~ json,
            let movement: Double = "movement" <~~ json else {
            return nil
        }

        self.temp = temp
        self.noise = noise
        self.co2 = co2
        self.movement = movement
    }


}

class SensorData: Decodable {

    let temp: Double
    let noise: Double
    let co2: Double
    let movement: Double

    let participantSensorData: [ParticipantSensorData]

    required init?(json: JSON) {
        guard let temp: Double = "temp" <~~ json,
            let noise: Double = "noise" <~~ json,
            let co2: Double = "co2" <~~ json,
            let movement: Double = "movement" <~~ json,
            let participantSensorData: [ParticipantSensorData] = "participant" <~~ json else {
            return nil
        }

        self.temp = temp
        self.noise = noise
        self.co2 = co2
        self.movement = movement
        self.participantSensorData = participantSensorData
    }


}
