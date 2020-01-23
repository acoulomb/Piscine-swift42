//
//  PlacesModel.swift
//  day05
//
//  Created by Aubane COULOMBIER on 12/16/19.
//  Copyright © 2019 Aubane COULOMBIER. All rights reserved.
//

import Foundation

struct Place {
    var id: Int
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
}

var Places: [Place] = [
    Place(id: 0, name: "42",description: "Une formation unique et une pédagogie révolutionnaire", latitude: 48.896886, longitude: 2.318544),
    Place(id: 1, name: "Eaubonne",description: "Commune du Val-d'Oise, dans la région Île-de-France", latitude: 48.992081, longitude: 2.277913),
    Place(id: 2, name: "Canal Saint-Martin",description: "Canal de 4,55 km de long situé essentiellement dans les 10ᵉ et 11ᵉ arrondissements de Paris", latitude: 48.870854, longitude: 2.366996),
    Place(id: 3, name: "Lyon",description: "Ville française de la région historique Rhône-Alpes", latitude: 45.764297, longitude: 4.834949)
]
