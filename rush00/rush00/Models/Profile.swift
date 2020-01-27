//
//  Profile.swift
//  rush00
//
//  Created by Alexandre KARASSOULOFF on 12/14/19.
//  Copyright © 2019 TeamJAJAJA. All rights reserved.
//

import Foundation

/*
 *  Default structure of cursus get on route /me
 */

struct UserCursusModel {
    var slug: String
    var level: Double
}

/*
 *  Default structure of user get on route /me
 */

struct UserModel {
    var id: Int
    var nom: String
    var prenom: String
    var login: String
    var urlPhotoProfile: String
}

var Profile: UserModel = UserModel(id: -1, nom: "", prenom: "", login: "", urlPhotoProfile: "")
var UserCursus: [UserCursusModel] = []
