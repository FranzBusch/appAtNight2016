//
//  NibDesignable.swift
//  Sixt-iOS
//
//  Created by franz busch on 03/09/16.
//  Copyright © 2016 e-Sixt GmbH & Co. KG. All rights reserved.
//

import UIKit

public protocol NibDesignable: class {
    var nibName: String { get }
    var nibContainerView: UIView { get }
}

extension NibDesignable {

    func setupNib() {
        let view = loadNib()
        nibContainerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
    }

    private func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self)) 
        let nib =  UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView // swiftlint:disable:this force_cast
    }

}

extension UIView {

    public var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last! // swiftlint:disable:this force_unwrapping
    }

    public var nibContainerView: UIView {
        return self
    }

}
