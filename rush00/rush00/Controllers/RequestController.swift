//
//  RequestController.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import Foundation

class RequestController {
    static func query(urlString: inout String, params: [String: String], headers: [String: String], method: String) -> URLRequest {

        var queryString: String = ""
        for (key, val) in params {
            queryString += "&\(key)=\(val)"
        }
        if method == "GET" {
            urlString += "?" + queryString
        }
        let url: URL = URL(string: urlString)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method
        if method == "POST" {
            request.httpBody = queryString.data(using: String.Encoding.utf8)
        }
        for (key, val) in headers {
            request.setValue(val, forHTTPHeaderField: key)
        }
        return request
    }
    
}
