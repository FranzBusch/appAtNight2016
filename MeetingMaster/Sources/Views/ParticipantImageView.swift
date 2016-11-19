//
//  ParticipantView.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import UIKit

enum ParticipantImageViewState {
    case green
    case orange
    case red
}

class ParticipantImageView: DesignableImageView {

    var state: ParticipantImageViewState = .red {
        didSet {
            switch state {
            case .red:
                layer.borderColor = UIColor.red.cgColor
            case .orange:
                layer.borderColor = UIColor.orange.cgColor
            case .green:
                layer.borderColor = UIColor.green.cgColor
            }
        }
    }

    override func applyStyling() {
        layer.cornerRadius = frame.size.width / 2
        layer.borderWidth = 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.red.cgColor
    }

}
