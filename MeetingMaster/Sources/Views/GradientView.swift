//
//  GradientView.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import UIKit

class GradientView: DesignableView {

    @IBInspectable var startColor: UIColor = UIColor.white {
        didSet {
            gradientLayer.removeFromSuperlayer()
            createGradientLayer()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.black {
        didSet {
            gradientLayer.removeFromSuperlayer()
            createGradientLayer()
        }
    }

    private var gradientLayer = CAGradientLayer()

    override func applyStyling() {
        createGradientLayer()
    }

    private func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]

        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

}

class StartGradientView: GradientView {

    override func applyStyling() {
        super.applyStyling()

        startColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3882352941, alpha: 1)
        endColor = #colorLiteral(red: 0.1607843137, green: 0.1960784314, blue: 0.2352941176, alpha: 1)
    }

}
