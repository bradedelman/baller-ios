//
//  NativeFont.swift
//  example
//
//  Created by Brad Edelman on 1/3/21.
//  Copyright © 2021 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit

class NativeFont {
    
    var _fonts: Dictionary<String, String> = Dictionary()
    
    func getFont(url: String) -> String
    {
        var name:String? = _fonts[url];
        
        if (name == nil) {
            // TODO: generalize font location support... want to be able to load from Internet, and not assume bundle location
            let path: String = Bundle.main.bundlePath + "/dist/" + (url as String);
            let fontFile = NSData(contentsOfFile: path)
            let provider = CGDataProvider(data: fontFile!)!
            let font = CGFont(provider)!
            
            name = font.fullName! as String;
            
            _fonts[url] = name;
            CTFontManagerRegisterGraphicsFont(font, nil);
        }
        
        if (name == nil) {
            return "";
        } else {
            return name!;
        }
    }

}


