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

    var _font: FontState?
    
    override func create() -> UIView
    {
        let v = TopAlignLabel()
        _font = FontState(native: _native!);
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
    @objc func fontFace(_ url: NSString, _ bSystem: NSNumber) {
        _font!.fontFace(url as String, bSystem.boolValue);
        fontCore();
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func fontSize(_ size: NSNumber) {
        _font!.fontSize(CGFloat(size.floatValue));
        fontCore();
    }

    func fontCore()
    {
        if (_e != nil) {
            let v = _e as! UILabel;            
            v.font = _font!.getFont();
        }
    }
}
