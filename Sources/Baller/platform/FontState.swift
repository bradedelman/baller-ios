//
//  File.swift
//  
//
//  Created by Brad Edelman on 1/18/21.
//

import Foundation
import UIKit

class FontState
{
    var _native: Native;
    var _fontFace: String = "";
    var _fontSize: CGFloat = 12.0;
    var _bSystem: Bool = false;
    
    init(native: Native)
    {
        _native = native;
    }
    
    func fontFace(_ url: String, _ bSystem: Bool)
    {
        _fontFace = url;
        _bSystem = bSystem;
    }
    
    func fontSize(_ size: CGFloat)
    {
        _fontSize = size;
    }
    
    func getFont() -> UIFont?
    {
        let fontName = _native._fonts.getFont(url: _fontFace, bSystem: _bSystem);
        if (fontName != "") {
            return UIFont(name: fontName, size: _fontSize);
        } else {
            return UIFont.systemFont(ofSize: _fontSize);
        }

    }
    
}
