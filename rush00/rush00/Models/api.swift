//
//  api.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import Foundation

struct Api {
    var client_id: String
    var client_secret: String
}

var apis: [String: Api] = [
    "42": Api(client_id: ft_client_id, client_secret: ft_client_secret)
]
