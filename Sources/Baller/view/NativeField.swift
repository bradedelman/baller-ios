//
//  NativeField.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit

// NOTE: most of the code here is about supporting "shift the view when the virtual keyboard appears"
// NOTE: should consider whether there's a better or more elegant solution, keeping in mind we
// NOTE: want to work as an SDK, so an "app global" solution may interfere with host app

open class NativeField : NativeView {

    var _save: CGRect = CGRect(x:0,y:0,width:0,height:0);
    var _font: FontState?
    
    override func create() -> UIView
    {
        let v:UITextField = UITextField()
        v.backgroundColor = .white;
        v.layer.borderColor = UIColor.black.cgColor;
        v.layer.borderWidth = 0.5;
        
        _font = FontState(native: _native!);
        
        // TODO: revisit
        // add a Done button so that the keyboard is dismissable
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapDone(sender:)))
        toolBar.setItems([flexible, barButton], animated: false)
        v.inputAccessoryView = toolBar

        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        return v;
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func getShiftView() -> UIView? {
        var result:UIView?;
        var v:UIView? = _e as? UITextField;
  
        if (v?.isFirstResponder == true) {
            while (v != nil) {
                if (v!.superview is BallerView) {
                    result = v;
                    break;
                }
                v = v?.superview;
            }
        }
        return result;
    }

    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let v:UIView? = _e as? UITextField;
        let shift:UIView? = getShiftView();
        if let shift = shift {
            if let v = v {

                // save the current frame
                _save = shift.frame;
                var r = _save;
                
                // TODO: revisit keyboard logic
                // get keyboard height
                guard let userInfo = notification.userInfo,
                             let kbSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                let keyboardHeight = kbSize.height;
                
                // get bottom of text field in screen coordinates
                let p = v.superview!.convert(v.frame.origin, to: nil);
                let fieldBottom = p.y + v.frame.size.height;
                
                // get height of window
                let windowHeight = v.window!.frame.height;
                                
                // so... if bottom of field is greater than the window height - the keyboard height, we need to scootch it up... so that it isn't
                let usableHeight = windowHeight - keyboardHeight;
                if (fieldBottom > usableHeight) {
                    var dy = fieldBottom - usableHeight;
                    
                    // add small buffer - 5% of keyboard height
                    dy = dy + 0.05 * keyboardHeight;
                    r = r.offsetBy(dx: 0.0, dy: -dy);
                }

                shift.frame = r;
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        let shift:UIView? = getShiftView();
        if let shift = shift {
            // restore frame
            shift.frame = _save;
        }
    }

    @objc func tapDone(sender: Any) {
        let v = _e as! UITextField;
        v.endEditing(true)
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func text(_ s: NSString) {

        if (_e != nil) {
            let v = _e as! UITextField;
            v.text = s as String;
        }
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func value() -> String {

        if (_e != nil) {
            let v = _e as! UITextField;
            return v.text! as String;
        }
        return "";
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func fontFace(_ url: NSString, _ bSystem: NSNumber) {
        _font!.fontFace(url as String, bSystem.boolValue);
        fontCore();
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func fontSize(_ size: NSNumber) {
        _font!.fontSize(CGFloat(size.floatValue));
        fontCore();
    }

    func fontCore()
    {
        if (_e != nil) {
            let v = _e as! UITextField;
            v.font = _font!.getFont();
        }
    }
}
