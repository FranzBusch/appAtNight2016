//
//  NibDesignableTableViewHeaderFooterView.swift
//  Sixt-iOS
//
//  Created by franz busch on 03/09/16.
//  Copyright © 2016 e-Sixt GmbH & Co. KG. All rights reserved.
//

import UIKit

@IBDesignable
open class NibDesignableTableViewHeaderFooterView: UITableViewHeaderFooterView, NibDesignable, Designable {

    override public var nibContainerView: UIView {
        return contentView
    }

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupNib()
        setup()
        applyStyling()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupNib()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        setup()
        applyStyling()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        applyStyling()
    }

    open func setup() {}
    open func applyStyling() {}

}
