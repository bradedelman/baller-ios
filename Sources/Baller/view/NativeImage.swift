//
//  NativeImage.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit

open class NativeImage : NativeView {

    override func create() -> UIView
    {
        return UIImageView()
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func url(_ url: NSString) {

        if (_e != nil) {
            let v = _e as! UIImageView;
            let u = URL(string: url as String)
            v.load(url: u!, placeholder: nil);
        }
    }
    
}
