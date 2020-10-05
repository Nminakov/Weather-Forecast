//
//  Constants.swift
//  Weather Forecast
//
//  Created by Никита on 12/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation

let weatherApiKey = "7fcaf06be8ef26802807e44f93b2d77f"

let latitude = "55.751244"
let longitude = "37.618423"

enum APIValue{
    static let baseUrl = "https://api.openweathermap.org/data/2.5"
    
    enum Methods: String{
        case get
        case post
        case patch
        case update
        case delete
        case put
    }
    
    enum Points: String{
        case onecall = "/onecall"
    }
}

