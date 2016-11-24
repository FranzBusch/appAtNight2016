//
//  Timeinterval.swift
//  MeetingMaster
//
//  Created by franz busch on 20/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Foundation

extension TimeInterval {
    var asStringHHmmss: String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var asMinutes: String {
        let minutes = self / 60
        return String(format: "%d", Int(minutes))
    }

    static func fromHHmmss(string: String) -> TimeInterval? {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        return date.timeIntervalSince1970
    }
}
