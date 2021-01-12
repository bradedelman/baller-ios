//
//  NativeStore.swift
//  example
//
//  Created by Brad Edelman on 12/30/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation

extension String {
subscript(_ i: Int) -> String {
  let idx1 = index(startIndex, offsetBy: i)
  let idx2 = index(idx1, offsetBy: 1)
  return String(self[idx1..<idx2])
}

subscript (r: Range<Int>) -> String {
  let start = index(startIndex, offsetBy: r.lowerBound)
  let end = index(startIndex, offsetBy: r.upperBound)
  return String(self[start ..< end])
}
}

class NativeStore : NativeService {
    
    var _store:Dictionary<String, Any> = Dictionary();

    func setRaw(key: String, value: Any)
    {
        _store[key] = value;
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func set(key: NSString, value: NSString)
    {
        let data = String(value).data(using: String.Encoding.utf8)
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: [])
            _store[String(key)] = json;
        } catch {
        }
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func get(key: NSString) -> NSString
    {
        return "";
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func getArrayCount(_ key: NSString, _ payload: NSString) -> NSNumber
    {
        let o:Any? = getCore(key, payload);
        
        let a:[Any] = (o as! [Any]);
        let n = NSNumber(integerLiteral: a.count);
        return n;
    }
    
    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func getFromJSON(_ key: NSString, _ payload: NSString) -> NSString
    {
        let o:Any? = getCore(key, payload);
        
        if (o != nil) {
            if (o is String) {
                return NSString.localizedStringWithFormat("\"%@\"", NSString(string: (o as! String)));
            }
            if (o is Int) {
                return NSString.localizedStringWithFormat("%@", NSNumber(integerLiteral: (o as! Int)));
            }
            if (o is Double) {
                return NSString.localizedStringWithFormat("%@", NSNumber(value: (o as! Double)));
            }
            if (o is Bool) {
                return NSString.localizedStringWithFormat("%@", NSNumber(booleanLiteral: (o as! Bool)));
            }
        }
        
        
        let json3:Any? = (o as? [String: Any])!;
        if (json3 != nil) {
            do {
                let output: Data? = try JSONSerialization.data(withJSONObject: json3!)
                if (output != nil) {
                    return NSString(string: String(decoding: output!, as: UTF8.self))
                }
            } catch {
                
            }
        }

        return "\"__FAIL__\"";
    }
    
    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func getCore(_ key: NSString, _ payload: NSString) -> Any?
    {
        // TODO: OMG THIS IMPLEMENTATON IS SUPER UGLY...
        
        let data: Data = Data(String(payload).utf8);
        let any: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
        let json = (any as? [String: Any])!;
        
        var path:String = json["_path"] as! String;
        let args:NSArray = json["_args"] as! NSArray;

        var o:Any? = _store[String(key)]!;

        var dot:String.Index? = path.endIndex;
        
        // HOLY COW - I DO NOT YET UNDERSTAND SWIFT STRINGS
        while (dot != nil && o != nil) { // keep going if more dots or found nothing
            dot = path.firstIndex(of: ".")
            var c: String = "";
            if (dot == nil) {
                c = path;
            } else {
                c = String(path[..<dot!])
            }
            let j = c.firstIndex(of: "[");
            let json2 = (o as? [String: Any])!;
            if (j != nil) {
                // indexing into array
                let k = c.firstIndex(of: "]");
                var index:String = String(c[j!..<k!]);
                index = String(index.dropFirst());
                let c = String(c[..<j!]);
                index = index.trimmingCharacters(in: .whitespacesAndNewlines);
                var n: Int;
                if (index[0] == "$") {
                    // it's a variable!
                    let q: String = String(index.dropFirst())
                    let v = Int(q)!;
                    n = args[v-1] as! Int;
                } else {
                    n =  Int(index)!;
                }
                let array:Any = json2[c]!;
                o = (array as! [Any])[n];
            } else {
                // indexing to non-array
                o = json2[c]!;
            }
            
            if (dot != nil) {
                path = String(path[dot!..<path.endIndex]);
                path = String(path.dropFirst());
            }
        }

        return o;
        
    }
}

