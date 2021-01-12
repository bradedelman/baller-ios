//
//  NativeScroll.swift
//  example
//
//  Created by Brad Edelman on 1/5/21.
//  Copyright © 2021 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit

open class NativeScroll : NativeView {

    override func create() -> UIView
    {
        return UIScrollView()
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func layoutChildren() {

        if (_e != nil) {
            let v = _e as! UIScrollView;
            var s = v.subviews[0].bounds.size;
            
            // force to be vertical only, since that's what Android ScrollView can do
            s.width = v.bounds.width;
            
            v.contentSize = s;
        }
    }
    
}
