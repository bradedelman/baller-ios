//
//  Console.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol ConsoleExports: JSExport {
    static  func log(_ s :String)
}

@objc class Console : NSObject, ConsoleExports {
    static public func log(_ s: String)
    {
        NSLog(s);
    }
}
