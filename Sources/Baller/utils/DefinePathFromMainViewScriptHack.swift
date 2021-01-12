//
//  DefinePathFromMainViewScriptHack.swift
//  example
//
//  Created by Brad Edelman on 1/10/21.
//  Copyright © 2021 Brad Edelman. All rights reserved.
//

import Foundation

class DefinePathFromMainViewScriptHack {
    
    static func getPath(script: String) -> String
    {
        var result = "_path_not_found_";
        
        // find last define("
        let token = "define(\"";
        let last = script.range(of: token, options:NSString.CompareOptions.backwards);
        if (last != nil) {
            let script2 = script.substring(from: last!.upperBound);            
            let next = script2.range(of: "\"");
            if (next != nil) {
                result = script2.substring(to: next!.lowerBound);
            }
        }
        
        return result;
        
    }
}
