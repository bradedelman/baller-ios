//
//  BallerView.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore

protocol BallerViewDelegate {
    func onEvent(_ name :String, _ value: String)
}

open class BallerView : UIView
{
    var _native: Native = Native(); // the 1 strong reference to Native
    var _content: NativeView?;
    var _scaledWidth: Int;
    var _scale: Float;
    var _delegate: BallerViewDelegate?;
       
    public init(scaledWidth:Int)
    {
        _scaledWidth  = scaledWidth;
        _scale = 1.0
        super.init(frame: CGRect.zero)
        clipsToBounds = true;
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        // TODO; revisit
        // without this, there's a memory leak
        // I think it has to do with a circular reference between JSContext and the Native instance
        // however, calling setObejct to clear "Native" doesn't fix it
        // I also tried putting the Native reference in a JSManagedValue...
        // for now, this fixes the leak acceptably until better understood.
        // for the most part, the weak references to Native in NativeView and NativeService, and the
        // weak reference to Baller host view in Native (and this) were the keys to making BallerViews
        // not leak memory (tested by making one, adding to view, removing in 200ms async... repeatedly
        _content?._native?._js = JSContext();
    }
    
    public func load(scriptContent: String)
    {
        // TODO; fix TypeScript compile so this isn't needed and the path is just always "MainView"
        // get the "define" path for the MainView we're loading
        let script = DefinePathFromMainViewScriptHack.getPath(script: scriptContent);
        
        // register services
        _native.addService(name: "NativeHttp", service: NativeHttp(native: _native));
        _native.addService(name: "NativeStore", service: NativeStore(native: _native));
        _native.addService(name: "NativeHost", service: NativeHost(native: _native, view: self));
        
        // register native code
        _native._js.setObject(Console.self, forKeyedSubscript: "console" as NSString);
        _native._js.setObject(_native.self, forKeyedSubscript: "Native" as NSString);
        
        // load/inject script runtme
        _native._js.evaluateScript(Scripts.json2);
        _native._js.evaluateScript(Scripts.Require);
        _native._js.evaluateScript(Scripts.Baller);
        _native._js.evaluateScript("Baller.getNative = function() {return Native;}");

        // load specific view script
        _native._js.evaluateScript(scriptContent);

        // start it up!
        _native._js.evaluateScript("Baller.init('" + script + "', '" + _native._nativeId + "')");
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        let contentView:UIView? = _content?._e;
        contentView?.frame = bounds;
        if (contentView == nil) {
            return;
        }
        let realWidth = bounds.width;
        if (realWidth == 0) {
            return;
        }
        _scale = Float(realWidth) / Float(_scaledWidth);
        contentView?.transform = CGAffineTransform(scaleX: CGFloat(_scale), y: CGFloat(_scale));
        let scaledHight: Int = Int(Float(bounds.height)/_scale);
        let _ = _content?.jsCall("doLayout", _scaledWidth, scaledHight);
    }
}
