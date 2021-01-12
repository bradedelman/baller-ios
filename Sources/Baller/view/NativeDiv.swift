//
//  NativeDiv.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit

open class NativeDiv : NativeView  {

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func setBgColor(_ color:NSString)
    {
        _e?.backgroundColor=UIColor(hex:color as String);
    }
}
