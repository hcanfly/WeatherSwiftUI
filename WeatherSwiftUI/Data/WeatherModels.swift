//
//  WeatherData.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct CurrentWeather : Decodable {
    let time: Int
    let summary: String?
    let icon: String?
    let temperature: Double?
    let apparentTemperature: Double?
    let dewPoint: Double?
    let humidity: Double?
    let pressure: Double?
    let windSpeed: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility: Double?     // 10 is max. Int?
}

struct DailyWeather : Decodable {
    let time: Int
    let summary: String?
    let icon: String?
    let sunriseTime: Int?
    let sunsetTime: Int?
    let temperatureHigh: Double?
    let temperatureLow: Double?
}

struct WeatherData : Decodable {
    let current: CurrentWeather
    let daily:  [DailyWeather]

    enum CodingKeys: String, CodingKey {
        case currently
        case daily
    }

    enum DailyCodingKeys: String, CodingKey {
        case data
    }
}

extension WeatherData  {

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current = try values.decode(CurrentWeather.self, forKey: .currently)

        // dig daily weather info "data" array from inside "hourly"
        let dailyInfo = try values.nestedContainer(keyedBy: DailyCodingKeys.self, forKey: .daily)
        daily = try dailyInfo.decode([DailyWeather].self, forKey: .data)
    }

}


/*
 // values not used not shown
 "currently": {
     "time": 1581977303,
     "summary": "Clear",
     "icon": "clear-day",
     "temperature": 69.81,
     "apparentTemperature": 69.81,
     "humidity": 0.21,
     "pressure": 1017.7,
     "windSpeed": 8.24,
     "windBearing": 339,
     "cloudCover": 0.1,
     "uvIndex": 3,
     "visibility": 10,
 },
 "daily": {
     "summary": "No precipitation throughout the week.",
     "icon": "clear-day",
     "data": [
         {
         "time": 1581926400,
         "summary": "Clear throughout the day.",
         "icon": "clear-day",
         "sunriseTime": 1581951420,
         "sunsetTime": 1581990660,
         "temperatureHigh": 70.39,
         "temperatureLow": 42.67,
         }
    ]
 */
