//
//  Native.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit

@objc protocol NativeExports: JSExport {
    
    func call6(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any, _ d: Any, _ e: Any, _ f: Any) -> Any?;
    func call5(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any, _ d: Any, _ e: Any) -> Any?;
    func call4(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any, _ d: Any) -> Any?;
    func call3(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any) -> Any?;
    func call2(_ id: String, _ method: String, _ a: Any, _ b: Any) -> Any?;
    func call1(_ id: String, _ method: String, _ a: Any) -> Any?;
    func call0(_ id: String, _ method: String) -> Any?;

    func callAPI2(_ apiName: String, _ method: String, _ a: Any, _ b: Any) -> Any?;
    func callAPI1(_ apiName: String, _ method: String, _ a: Any) -> Any?;

}

@objc open class Native : NSObject, NativeExports {
    
    var _nativeId: String = "NATIVE";
    var _js: JSContext = JSContext();
    var _views: Dictionary<String, NativeView> = Dictionary()
    var _services: Dictionary<String, NSObject> = Dictionary();
    var _fonts: NativeFont = NativeFont();
    

    // serves 2 purposes
    // 1. work around unreferenced classes getting stripped in static lib configuation (fails when not referenced)
    // 2. avoid problem with full class path being different depending how compiled (full test app, static lib, etc)
    func createNativeView(nativeType:String) -> NativeView?
    {
        switch (nativeType) {
        case "NativeButton": return NativeButton(native: self);
        case "NativeDiv": return NativeDiv(native: self);
        case "NativeField": return NativeField(native: self);
        case "NativeImage": return NativeImage(native: self);
        case "NativeLabel": return NativeLabel(native: self);
        case "NativeList": return NativeList(native: self);
        case "NativeScroll": return NativeScroll(native: self);
        default:
            return nil;
        }
    }

    func addService(name: String, service: NativeService)
    {
        _services[name] = service;
    }
    
    func jsCreate(jsTypeId: String) -> NativeView?
    {
        let s: String = "Baller.create('" + _nativeId + "', '" + jsTypeId + "')";
        let viewId = _js.evaluateScript(s);
        return _views[viewId!.toString()];
    }
    
    // TODO: NativeView.jsCall doesn't call this because not sure how to forward the varargs...
    func jsCall(_ _id:String, _ method:String,  _ args: Any ...) -> Any?
    {
        var s: String = "Baller.call('" + _nativeId + "', '" + _id + "', '" + method + "'";
        for arg in args {
            if (arg is String) {
                s += ", " + "\"\(arg)\""
            } else {
                s += ", " + "\(arg)"
            }
        }
        s += ")";
        
        let result:JSValue = _js.evaluateScript(s);
        return result.toObject();
    }

    func call(_ id: String, _ method: String, _ args: [Any]) -> Any?
    {
        let v: NativeView? = _views[id];
        if (v != nil) {
            return CallNamedMethod.call(object: v!, method: method, args: args);
        }
        return nil;
    }
        
    func call6(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any, _ d: Any, _ e: Any, _ f: Any) -> Any?
    {
        return call(id, method, [a, b, c, d, e, f]);
    }
    
    func call5(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any, _ d: Any, _ e: Any) -> Any?
    {
        return call(id, method, [a, b, c, d, e]);
    }
    
    func call4(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any, _ d: Any) -> Any?
    {
        return call(id, method, [a, b, c, d]);
    }
    
    func call3(_ id: String, _ method: String, _ a: Any, _ b: Any, _ c: Any) -> Any?
    {
        return call(id, method, [a, b, c]);
    }
    
    func call2(_ id: String, _ method: String, _ a: Any, _ b: Any) -> Any?
    {
        return call(id, method, [a, b]);
    }
    
    func call1(_ id: String, _ method: String, _ a: Any) -> Any?
    {
        return call(id, method, [a]);
    }
    
    func call0(_ id: String, _ method: String) -> Any?
    {
        return call(id, method, []);
    }

    func callAPI2(_ apiName: String, _ method: String, _ a: Any, _ b: Any) -> Any?
    {
        let api = _services[apiName];
        if (api != nil) {
            return CallNamedMethod.call(object: api!, method: method, args: [a,b]);
        }
        return nil;
    }
    
    func callAPI1(_ apiName: String, _ method: String, _ a: Any) -> Any?
    {
        let api = _services[apiName];
        if (api != nil) {
            return CallNamedMethod.call(object: api!, method: method, args: [a]);
        }
        return nil;
    }

}
