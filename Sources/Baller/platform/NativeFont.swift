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
    
    func getFont(url: String, bSystem: Bool) -> String
    {
        var name:String? = _fonts[url];
        
        if (name == nil) {
            
            // TODO: generalize font location support... want to be able to load from Internet, and not assume bundle location
            var path: String = Bundle.main.bundlePath + "/dist/" + (url as String);

            if (bSystem) {
                // support for "built-in" fonts that are included in the Baller Swift Pacakge
                path = Bundle.module.bundlePath + "/baller-assets/" + url;
            }

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


