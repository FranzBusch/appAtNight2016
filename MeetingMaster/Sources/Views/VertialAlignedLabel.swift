//
//  VertialAlignedLabel.swift
//  MeetingMaster
//
//  Created by franz busch on 20/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import UIKit

class UIVerticalAlignLabel: UILabel {

    enum VerticalAlignment : Int {
        case Top = 0
        case Middle = 1
        case Bottom = 2
    }

    var verticalAlignment : VerticalAlignment = .Top {
        didSet {
            setNeedsDisplay()
        }
    }

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)

        switch(verticalAlignment) {
        case .Top:
            return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
        case .Middle:
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
        case .Bottom:
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
        }
    }

    override func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
