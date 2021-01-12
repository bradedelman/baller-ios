//
//  NativeLabel.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit


open class NativeLabel : NativeView {

    override func create() -> UIView
    {
        let v = TopAlignLabel()
        v.numberOfLines = 0; // allow as many lines as will fit
        return v;
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func text(_ s: NSString) {

        if (_e != nil) {
            let v = _e as! UILabel;
            v.text = s as String;
        }
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func font(_ url: NSString, _ size: NSNumber) {

        if (_e != nil) {
            let v = _e as! UILabel;
            v.font = UIFont(name: _native!._fonts.getFont(url: url as String), size: 1.06 * CGFloat(size.floatValue)); // TODO: revisit "schluff factor"
        }
    }
    
}
