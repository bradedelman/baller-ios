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

    override func create() -> UIView
    {
        let v = UIButton(type: .system)
     
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
    @objc func font(_ url: NSString, _ size: NSNumber) {

        if (_e != nil) {
            let v = _e as! UIButton;
            v.titleLabel?.font = UIFont(name: _native!._fonts.getFont(url: url as String), size: 1.06 * CGFloat(size.floatValue)); // TODO: revisit "schluff factor"
        }
    }
    
}
