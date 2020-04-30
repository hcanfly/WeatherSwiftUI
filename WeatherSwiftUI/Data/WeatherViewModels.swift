//
//  WeatherDataModel.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/19/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI
import Combine


// you need a Dark Sky API key to download weather.
// Apple just bought Dark Sky and aren't issuing new API keys.
// Sigh. The weather APIs just keep going away.

// overview of Dark Sky API
// https://darksky.net/dev/docs



let darkskyApiKey = "<Your Dark Sky API key goes here>"      // "<Your Dark Sky API key goes here>"
let myLatLong = "37.3894,-122.0832"         // lat / long for good old Mountain View
let cityName = "Mountain View"
let darkSkyURL = "https://api.darksky.net/forecast/\(darkskyApiKey)/\(myLatLong)?exclude=minutely,alerts,flags"



final class WeatherDataViewModel: ObservableObject {
    @Published var current: CurrentWeather
    @Published var daily: [DailyWeatherViewModel] = []
    @Published var hourly: HourlyWeather

    private var disposables = Set<AnyCancellable>()
    private let weatherFetcher = DataFetcher()

    init() {
        // need to initialize to nil because views will be displayed before data arrives
        current = CurrentWeather(time: 0, summary: nil, icon: nil, temperature: nil, apparentTemperature: nil, dewPoint: nil, humidity: nil, pressure: nil, windSpeed: 6.0, windBearing: nil, cloudCover: nil, uvIndex: nil, visibility: nil)
        hourly = HourlyWeather(summary: nil, icon: nil)
    }

    var summary: String {
        return current.summary ?? ""
    }

    var iconName: String {

        return iconForName(forIcon: current.icon)
    }

    var temperature: String {
        return doubleToRoundedString(current.temperature)
    }

    var uvIndexColor: Color {
        return current.uvIndex != nil ? UVIndex(value: current.uvIndex!).color : Color.blue
    }

    var highTemperature: String {
        return daily.count > 0 ? daily[0].highTemperature : ""      // daily[0] is today
    }

    var lowTemperature: String {
        return daily.count > 0 ? daily[0].lowTemperature : ""
    }

    var feelsLike: String {
       return doubleToRoundedString(current.apparentTemperature)
    }

    var humidity: String {
       return doubleToRoundedString(current.humidity)
    }

    var visibility: String {
       return doubleToRoundedString(current.visibility)
    }

    var windSpeed: String {
        return doubleToRoundedString(current.windSpeed)
    }

    var bladeDuration: Double {
        var speed = 0.0       // this is actually rotation duration - less is faster (well, if > 0)

        guard let windSpeed = current.windSpeed else {
            return 0.0
        }

        if windSpeed > 11 {
            speed = 4
        } else if windSpeed > 7 {
            speed = 8
        } else if windSpeed > 4 {
            speed = 12
        } else if windSpeed > 1.2 {
            speed = 16
        }

        return speed
    }

    var windDirection: String {
        return getWindDirection(degrees: current.windBearing)
    }

    var barometer: String {
        return millibarsToInches(mbars: current.pressure)
    }

    var hourlySummary: String {
        return hourly.summary ?? ""
    }

}

extension WeatherDataViewModel {

    func getWeather() {
        assert( !darkSkyURL.contains("Your Dark Sky API key goes here"), "You need to get an API key from darksky")
        weatherFetcher.fetch(urlString: darkSkyURL, myType: WeatherData.self)   // download weather data
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished: break
                    case .failure(let anError):
                        print("received error: ", anError)
                    }
            }, receiveValue: { someValue in
                // store weather data in our models
                self.current = someValue.current
                self.hourly = someValue.hourly
                self.daily = someValue.daily.map {
                    DailyWeatherViewModel(m: $0)
                }
            })
            .store(in: &disposables)
    }
}


struct DailyWeatherViewModel {
    let m: DailyWeather

    var dayOfWeek: String {

        let d = date(from: m.time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: d)

        return dayOfTheWeekString
    }

    var iconName: String {
        return iconForName(forIcon: m.icon)
    }
    var highTemperature: String {
        return doubleToRoundedString(m.temperatureHigh)
    }

    var lowTemperature: String {
        return doubleToRoundedString(m.temperatureLow)
    }

    private func date(from unixTime: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(unixTime))
    }
}


//MARK: utilities for formatting data
    enum UVIndex {
        case high
        case medium
        case mediumHigh
        case low

        // US EPA index
        init(value: Int) {
            switch value {
                case 0...2:
                    self = .low
                case 3...5:
                    self = .medium
                case 6...7:
                    self = .mediumHigh
                default:
                    self = .high
            }
        }

        var color: Color {
            switch self {
                case .high:
                    return Color.red
                case .mediumHigh:
                    return Color.orange
                case .medium:
                    return Color.yellow
                case .low:
                    return Color.green
            }
        }
    }

    fileprivate func getWindDirection(degrees: Int?) -> String {
      var dir = "N"

        guard let degrees = degrees else {
            return dir
        }

      if (degrees > 340) {
        dir = "N"
      } else if (degrees > 290) {
        dir = "NW"
      } else if (degrees > 250) {
        dir = "W"
      } else if (degrees > 200) {
        dir = "SW"
      } else if (degrees > 160) {
        dir = "S"
      } else if (degrees > 110) {
        dir = "SE"
      } else if (degrees > 70) {
        dir = "E"
      } else if (degrees > 20) {
        dir = "NE"
      }

      return dir
    }

    fileprivate func millibarsToInches(mbars: Double?) -> String {
        guard let mbars = mbars else {
            return "0.00"
        }

      let inches = mbars * 0.0295301

      return String(format: "%.1f", inches)
    }


    fileprivate func iconForName(forIcon: String?) -> String {
        guard let icon = forIcon else {
            return "sun.max.fill"     // this will happen before downloading is finished
        }

        switch icon {
            case "clear-day":
                return "sun.max.fill"
            case "clear-night":
                return "moon.stars"
            case "rain":
                return "cloud.rain"
            case "snow":
                return "snow"
            case "sleet":
                return "cloud.sleet"
            case "wind":
                return "wind"
            case "fog":
                return "cloud.fog"
            case "cloudy":
                return "cloud.fill"
            case "partly-cloudy-day":
                return "cloud.sun.fill"
            case "partly-cloudy-night":
                return "cloud.moon.fill"
            default:
                return "cloud.sun.bolt"
        }
    }

    fileprivate func doubleToRoundedString(_ dbl: Double?) -> String {
        guard let dbl = dbl else {
            return ""
        }

        return "\(Int(dbl.rounded()))"
    }

