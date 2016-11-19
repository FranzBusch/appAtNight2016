//
//  RoundedCornerButton.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import UIKit

class RoundedCornerButton: DesignableButton {

    override func applyStyling() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

}

class WhiteRoundedCornerButton: RoundedCornerButton {

    override func applyStyling() {
        super.applyStyling()

        backgroundColor = UIColor.white
        setTitleColor(#colorLiteral(red: 0.2274509804, green: 0.3254901961, blue: 0.6078431373, alpha: 1), for: .normal)
    }

}
