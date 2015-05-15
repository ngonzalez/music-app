//
//  BaseController.swift
//  MusicApp
//
//  Created by enyo on 2015-04-12.
//  Copyright (c) 2015 enyo. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    var ApiURL = "http://192.168.0.102:9292"

    func getData(path: String, fn: (NSArray) -> ()) {
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string: path)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let results = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
                fn(results)
            }
        })
    }

}