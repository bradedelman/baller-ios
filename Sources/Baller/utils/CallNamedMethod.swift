//
//  CallNamedMethod.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import CallNamedMethod

class CallNamedMethod {
    
    static func call(object:NSObject, method:String, args:[Any]) -> Any?
    {
        // args need to be NSObject types...
        var args2:Array = Array<NSObject>();
        
        let count = Array<Any>(args).count;
        for i in 0..<count {
            let arg:Any = args[i];
            switch arg {
            case is String:args2.append(NSString(string: arg as! String)); break;
            case is Int:args2.append(NSNumber(integerLiteral: arg as! Int)); break;
            case is Bool:args2.append(NSNumber(booleanLiteral: arg as! Bool)); break;
            case is Double:args2.append(NSNumber(value: arg as! Double)); break;
            default: args2.append(NSNull()); break;
            }
        }
        
        return CallNamedMethodFunc(object, method, args2);
    }

}
