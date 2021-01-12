//
//  NativeHttp.swift
//  example
//
//  Created by Brad Edelman on 12/30/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation

class NativeHttp : NativeService {
    
    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func send(_ dataStr: NSString) {
              
        let data: Data = Data(String(dataStr).utf8);
        let any: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
        let json = (any as? [String: Any])!;
        
        let urlString:String = json["_url"] as! String;
        let method:String = json["_verb"] as! String;
        let onError:String = json["_onError"] as! String;
        let onSuccess:String = json["_onSuccess"] as! String;
        let viewId:String = json["_viewId"] as! String;
        let storeId:String = json["_storeId"] as! String;

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method;
        
        if (json["_headers"] != nil) {
            let headers:[String: Any] = json["_headers"] as! [String: Any];
            for (header, value) in headers {
                let s = value as! String;
                request.addValue(s, forHTTPHeaderField: header);
            }
        }

        if (json["_body"] != nil) {
            let body:String = json["_body"] as! String;
            let data = body.data(using: String.Encoding.utf8)
            request.httpBody=data
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // important to process result on main UI thread
            DispatchQueue.main.async {
                if error != nil || data == nil {
                    let _ = self._native!.jsCall(viewId, onError, "Client error!")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    let _ = self._native!.jsCall(viewId, onError, "Oops!! there is server error!")
                    return
                }
                
                guard let mime = response.mimeType, mime == "application/json" else {
                    let _ = self._native!.jsCall(viewId, onError, "response is not json")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])

                    let nativeStore: NativeStore = self._native?._services["NativeStore"] as! NativeStore;
                    let _ = nativeStore.setRaw(key: storeId, value: json);
                    let _ = self._native!.jsCall(viewId, onSuccess)

                } catch {
                    let _ = self._native!.jsCall(viewId, onError, "JSON error: \(error.localizedDescription)")
                }
        }
            
        })
        
        task.resume()
    }

}


