//
//  NatveView.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore

open class NativeView : NSObject {
    
    weak var _native: Native?;
    var _e: UIView?;
    var _id: String = "";

    public required init(native: Native)
    {
        _native = native;
    }
    
    func setView(e: UIView)
    {
        _e = e;
    }

    func create() -> UIView
    {
        let v:UIView = UIView()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.onTapGesture (_:)))
        v.addGestureRecognizer(gesture)
        return v;
    }

    @objc func onTapGesture(_ sender:UITapGestureRecognizer)
    {
        let p:CGPoint = sender.location(in: _e);
        onUp(x: Int(p.x), y: Int(p.y));
    }

    func onUp(x: Int, y: Int)
    {
        let _ = jsCall("onUp", x, y);
    }
    
    func jsCall(_ method:String,  _ args: Any ...) -> Any?
    {
        var s: String = "Baller.call('" + _native!._nativeId + "', '" + _id + "', '" + method + "'";
        for arg in args {
            if (arg is String) {
                s += ", " + "\"\(arg)\""
            } else {
                s += ", " + "\(arg)"
            }
        }
        s += ")";
        
        let result:JSValue = _native!._js.evaluateScript(s);
        return result.toObject();
    }


    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func setBounds(_ x: NSNumber, _ y: NSNumber, _ w: NSNumber, _ h: NSNumber)
    {
        _e?.frame = CGRect(x: x.intValue, y: y.intValue, width: w.intValue, height: h.intValue)
    }
}
