//
//  NativeService.swift
//  example
//
//  Created by Brad Edelman on 1/10/21.
//  Copyright © 2021 Brad Edelman. All rights reserved.
//

import Foundation

class NativeService : NSObject {
    
    weak var _native: Native?;
    
    init(native: Native)
    {
        _native = native;
    }

}

