//
//  UIViewController+ErrorHandling.swift
//  MeetingMaster
//
//  Created by franz busch on 19/11/2016.
//  Copyright © 2016 Whats'on. All rights reserved.
//

import UIKit

extension UIViewController {

    @discardableResult func handle<Value>(_ result: Result<Value, ServiceError>) -> Value? {
        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            show(error)
        }

        return nil
    }


    private func show(_ error: ServiceError) {
        if case let .networking(error) = error, error.isCancelled {
            return
        }

        let title = "Error"
        var message = "Oops, Looks like something went wrong."

        if case let .backend(error) = error {
            message = error.message
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.show()
    }
    
}

