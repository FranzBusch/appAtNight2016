//
//  CircleView.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import Foundation

class CircleView: DesignableView {

    override func applyStyling() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }

}
