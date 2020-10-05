//
//  Request.swift
//  Weather Forecast
//
//  Created by Никита on 20/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation


struct Request: Codable {
    var lat: String
    var lon: String
    var exclude: String
    var appid: String
    var units: String
    var lang: String
    
    
    init(lat: String = latitude,
         lon: String = longitude,
         exclude: String,
         appid: String = weatherApiKey,
         units: String,
         lang: String)
    {
        self.lat = lat
        self.lon = lon
        self.exclude = exclude
        self.appid = appid
        self.units = units
        self.lang = lang
    }
}
