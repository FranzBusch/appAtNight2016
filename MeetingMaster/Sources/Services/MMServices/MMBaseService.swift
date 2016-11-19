//
//  MMBaseService.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Foundation

struct MMBaseService: BaseService {

    static var provider = NetworkingProvider<MMBaseTarget>()

    @discardableResult static func fetchMeeting(completion: ((Result<Meeting, ServiceError>) -> Void)?) -> Cancellable {
        return request(target: .fetchMeeting, completion: completion)
    }

    @discardableResult static func fetchSensorData(for id: Int, completion: ((Result<Meeting, ServiceError>) -> Void)?) -> Cancellable {
        return request(target: .sensorData(id), completion: completion)
    }

}
