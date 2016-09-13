//
//  Request.swift
//  Unagi
//
//  Created by ikbal kazar on 12/09/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftHTTP

let serverHost = "http://localhost:8080";

class Request {
    class func get(host: String, andPath urlPath: String, andCompletion successCompletion: (JSON) -> ()) {
        do {
            let opt = try HTTP.GET(host + urlPath)
            opt.start { response in
                if let error = response.error {
                    print(error)
                    return
                }
                let data = response.data
                successCompletion(JSON(data: data))
            }
        } catch {
            print("Request Error")
        }
    }
}
