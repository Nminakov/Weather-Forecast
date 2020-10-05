//
//  Response.swift
//  Weather Forecast
//
//  Created by Никита on 20/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation

struct Response: Codable {
    var current: CurrentResponse?
    var hourly: [HourlyResponse]?
    var daily: [DailyResponse]?
}

struct CurrentResponse: Codable {
    var datetime: Int // текущее время на запрос
    var sunrise: Int // время восхода солнца
    var sunset: Int // время захода солнца
    var temp: Double // температура
    var feelsLike: Double // по ощущениям
    var pressure: Int // давление
    var humidity: Int // плажность
    var uvi: Double
    var clouds: Int // процент облачности
    var visibility: Int // в метрах
    var windSpeed: Int // скорость ветра м/с
    var weather: [WeatherResponseModel]?
    
    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, temp, pressure, humidity, uvi, clouds, visibility, weather
        case datetime  = "dt"
        case windSpeed = "wind_speed"
        case feelsLike = "feels_like"
    }
}

struct HourlyResponse: Codable {
    var datetime: Int // текущее время на запрос
    var temp: Double // температура
    var feelsLike: Double // по ощущениям
    var pressure: Int // давление
    var humidity: Int // плажность
    var clouds: Int // процент облачности
    var visibility: Int // в метрах
    var windSpeed: Double // скорость ветра м/с
    var weather: [WeatherResponseModel]
    
    
    var formattedDate: Date{
        let date = Date(timeIntervalSince1970: TimeInterval(datetime))
        return date
    }
    
    var isToday: Bool{
        let todayDate = Date()
        let modelDate = formattedDate
        let result = Calendar.current.compare(todayDate, to: modelDate, toGranularity: .day) == .orderedSame
        return result
    }
    
    var isTmorrow: Bool{
        let calendar = Calendar.current
        let todayDate = Date()
        let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: todayDate) ?? todayDate
        let modelDate = formattedDate
        let result = calendar.compare(tomorrowDate, to: modelDate, toGranularity: .day) == .orderedSame
        return result
    }
    
    var formattedTime: String{
        let modelDate = formattedDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.timeStyle = .short
        let timeString = dateFormatter.string(from: modelDate)
        return timeString
    }
    
    enum CodingKeys: String, CodingKey {
        case datetime  = "dt"
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case temp, pressure, humidity, clouds, visibility, weather
    }
}

struct DailyResponse: Codable {
    var datetime: Int // текущее время на запрос
    var sunrise: Int // время восхода солнца
    var sunset: Int // время захода солнца
    var temp: TempResponseModel? // модель температурных значений
    var feelsLike: FeelsLikeResponseModel? // модель температурных значений по ощущениям
    var pressure: Int // давление
    var humidity: Int // плажность
    var clouds: Int // процент облачности
    var windSpeed: Double // скорость ветра м/с
    var weather: [WeatherResponseModel]?
    var uvi: Double
    
    enum CodingKeys: String, CodingKey {
        case datetime  = "dt"
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case sunrise, sunset, temp, pressure, humidity, clouds, weather, uvi
    }
}

struct WeatherResponseModel: Codable {
    var main: String
    var description: String
    var icon: String
}


struct TempResponseModel: Codable {
    var day: Double
    var min: Double
    var max: Double
    var night: Double
    var eve: Double
    var morn: Double
}

struct FeelsLikeResponseModel: Codable {
    var day: Double
    var night: Double
    var eve: Double
    var morn: Double
}
