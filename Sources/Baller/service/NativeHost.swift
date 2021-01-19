//
//  NativeHost.swift
//  example
//
//  Created by Brad Edelman on 1/7/21.
//  Copyright © 2021 Brad Edelman. All rights reserved.
//

import Foundation

class NativeHost : NativeService {

    weak var _hostView: BallerView?;

    init(native: Native, view: BallerView)
    {
        _hostView = view;
        super.init(native: native);
    }
    
    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func onEvent(_ name: NSString, _ value: NSString) {
        _hostView?._delegate?.onEvent(name as String, value as String);
    }
    
    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func create(_ nativeTypeNS: NSString, _ idNS: NSString)
    {
        let nativeType = String(nativeTypeNS);
        let id = String(idNS);
            
        let nv:NativeView? = _native?.createNativeView(nativeType: nativeType);
        if (nv != nil) {
            let v = nv?.create();
            nv?.setView(e: v!)
            nv?._id = id;
            _native!._views[id] = nv;
        }
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func addChild(_ parentIdNS: NSString, _ childIdNS: NSString)
    {
        let parentId = String(parentIdNS);
        let childId = String(childIdNS);
        
        let parent = _native!._views[parentId];
        let child = _native!._views[childId];
        let parentView = parent?._e;
        let childView = child?._e;
        parentView?.addSubview(childView!);
    }
    
    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func finishInit(_ nativeTypeNS: NSString)
    {
        let nativeType = String(nativeTypeNS);

        let nv = _native!.jsCreate(jsTypeId:nativeType, parentId: "");
        let view = nv?._e;
        _hostView?.addSubview(view!);
        _hostView?._content = nv;
    }
}


