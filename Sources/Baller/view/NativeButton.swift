//
//  NativeButton.swift
//  example
//
//  Created by Brad Edelman on 1/7/21.
//  Copyright © 2021 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit

open class NativeButton : NativeView {

    var _font: FontState?;
    
    override func create() -> UIView
    {
        let v = UIButton(type: .system)
     
        _font = FontState(native: _native!);
        
        v.setTitleColor(.black, for: .normal)
        v.layer.borderColor = UIColor.black.cgColor;
        v.layer.borderWidth = 1
        v.backgroundColor = UIColor(hex: "#EEEEEE")
        v.addTarget(self, action:#selector(onClicked), for: .touchUpInside)
        return v;
    }

    @objc
    func onClicked(sender: UIButton)
    {
        let _ = jsCall("onClick");
    }
    
    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func text(_ s: NSString) {

        if (_e != nil) {
            let v = _e as! UIButton;
            v.setTitle(s as String, for: .normal)
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
            let v = _e as! UIButton;
            v.titleLabel?.font = _font!.getFont();
        }
    }
    
}
