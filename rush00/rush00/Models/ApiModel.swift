//
//  ApiModel.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import Foundation

/*
 *  Default representation of api
 */
struct Api {
    var client_id: String
    var client_secret: String
}


/*
 *  Dictionary of api
 */

let api: [String: Api] = [
    "42": Api(client_id: ft_client_id, client_secret: ft_client_secret)
]

/*
 *  Store of access_token
 */

var storeToken: [String: String] = [:]
