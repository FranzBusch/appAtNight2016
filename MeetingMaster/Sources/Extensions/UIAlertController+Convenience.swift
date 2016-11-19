//
//  UIAlertController+Convenience.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import UIKit

extension UIAlertController {

    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }

        var nextVC = rootVC
        while let presentedVC = nextVC.presentedViewController {
            nextVC = presentedVC
        }

        nextVC.present(self, animated: animated, completion: completion)
    }
    
}
