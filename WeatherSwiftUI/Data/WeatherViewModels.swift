//
//  WeatherDataModel.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/19/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI

let degreesChar = "°"


final class ViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case failed(NetworkError)
        case loaded(WeatherData)
    }

    //@Published private(set) var state = State.idle    // can't be private with getWeather extension in a separate file
    @Published var state = State.idle
    
    var weatherData = WeatherData()
    var current: CurrentData  { return weatherData.current }
    var forecast: ForecastData  { return weatherData.forecast }

    
// just for testing and previews
//    init() {
//        let current = CurrentData(LocalObservationDateTime: "", EpochTime: 23423434, WeatherText: "Partly Cloudy", WeatherIcon: 7, PrecipitationType: nil, IsDayTime: true, Temperature: ImperialInfo(Imperial: AccuValue(Value: 55, Unit: "F")), RealFeelTemperature: ImperialInfo(Imperial: AccuValue(Value: 60, Unit: "F")), RelativeHumidity: 22, Wind: WindInfo(Direction: DirectionDetail(Degrees: 268, Localized: "NW"), Speed: ImperialInfo(Imperial: AccuValue(Value: 26, Unit: "mi/h"))), UVIndex: 4, Visibility: ImperialInfo(Imperial: AccuValue(Value: 10, Unit: "in")), Pressure: ImperialInfo(Imperial: AccuValue(Value: 29.81, Unit: "inHg")), ApparentTemperature: ImperialInfo(Imperial: AccuValue(Value: 64.0, Unit: "F")), WindChillTemperature: ImperialInfo(Imperial: AccuValue(Value: 55.5, Unit: "F")))
//
//        let forecast = ForecastData(DailyForecasts: [DailyData(Date: "", EpochDate: 789798, Temperature: ForecastTemperatureInfo(Minimum: AccuValue(Value: 50, Unit: "F"), Maximum: AccuValue(Value: 88, Unit: "F")), Day: ConditionsInfo(Icon: 6, IconPhrase: ""))])
//
//        self.weatherData = WeatherData()
//        self.weatherData.current = current
//        self.weatherData.forecast = forecast
//    }
}

struct ForecastInfo {
    let dow: String
    let icon: String
    let min: String
    let max: String
}


//MARK: utilities for formatting data

fileprivate func millibarsToInchesString(millibars: Int?) -> String {
      guard let millibars = millibars else {
          return "0.00 in."
      }

    let inches = Double(millibars) * 0.0295301

    return String(format: "%.1f", inches) + " in."
}

fileprivate func pressureInInchesString(inches: Double) -> String {

    return String(format: "%.1f", inches) + " in."
}

fileprivate func metersToMilesString(meters: Int?) -> String {
    guard let meters = meters else {
        return "n/a"
    }

    let miles = Double(meters) / 1609.34
    return "\(Int(miles.rounded()))" + " mi"
}

fileprivate enum UVIndex {
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
                return .red
            case .mediumHigh:
                return .orange
            case .medium:
                return .yellow
            case .low:
                return .green
        }
    }
}

fileprivate func getWindDirection(degrees: Double?) -> String {
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

fileprivate func doubleToRoundedString(dbl: Double?) -> String {
    guard let dbl = dbl else {
        return ""
    }

    guard dbl != 0.0 else {
        return "0"
    }

    return "\(Int(dbl.rounded()))"
}

fileprivate extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

fileprivate func dateToString(date: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(date))
    let formatter = DateFormatter()

    formatter.dateFormat = "MMM dd, YYYY"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.locale = NSLocale.current

    let updatedDateStr = formatter.string(from: date)
    return updatedDateStr
}

fileprivate func dowFrom(date: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(date))
    let formatter = DateFormatter()

    formatter.dateFormat = "EEEE"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.locale = NSLocale.current

    let dow = formatter.string(from: date)
    return dow
}


struct WeatherData {
    var current: CurrentData!
    var forecast: ForecastData!
    
    //MARK: - Current Conditions view
    var temperature: String {
        return doubleToRoundedString(dbl: self.current.Temperature.Imperial.Value)
    }

    var currentConditions: String {
        return self.current.WeatherText
    }

    var highTemp: String {
        return doubleToRoundedString(dbl: self.forecast.DailyForecasts[0].Temperature.Maximum.Value)
    }

    var lowTemp: String {
        return doubleToRoundedString(dbl: self.forecast.DailyForecasts[0].Temperature.Minimum.Value)
    }

    var weatherIcon: UIImage? {
        return getWeatherIcon(icon: self.current.WeatherIcon)
    }

    func getWeatherIcon(icon: Int) -> UIImage {
        var iconString = ""
        if icon < 10 {
            iconString += "0\(icon)"
        } else {
            iconString += "\(icon)"
        }
        iconString += "-s"

        return UIImage(named: iconString)!
    }

    var weatherIconName: String {
        return getWeatherIconName(icon: self.current.WeatherIcon)
    }

    func getWeatherIconName(icon: Int) -> String {
        var iconString = ""
        if icon < 10 {
            iconString += "0\(icon)"
        } else {
            iconString += "\(icon)"
        }
        iconString += "-s"

        return iconString
    }


    var isRaining: Bool {
        self.current.PrecipitationType != nil && self.current.PrecipitationType == "Rain"
    }

    //MARK: -  Details panel
    var feelsLike: String {
        return doubleToRoundedString(dbl: self.current.ApparentTemperature.Imperial.Value) + degreesChar
    }

    var uvIndexColor: Color {
        return self.current.UVIndex != nil ? UVIndex(value: self.current.UVIndex!).color : .blue
     }

    var humidity: String {
        return self.current.RelativeHumidity != nil ? "\(self.current.RelativeHumidity!)" + "%" : "n/a"
    }

    var visibility: String {
        return doubleToRoundedString(dbl: self.current.Visibility.Imperial.Value) + " mi"
    }

    //MARK: -  Wind and Pressure panel
    var windSpeedString: String {
        if (self.current.Wind.Speed?.Imperial.Value == nil || (self.current.Wind.Speed?.Imperial.Value)! < 0.5) {
            return "0"
        }
        return doubleToRoundedString(dbl: self.current.Wind.Speed?.Imperial.Value)
    }

    var windSpeed: Double? {
        return self.current.Wind.Speed?.Imperial.Value
    }

    var bladeDuration: Double {
        var speed: Double = 100      // this is actually rotation duration - less is faster (well, if > 0)
        guard let windSpeed = self.windSpeed else {
            return speed
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
        return self.current.Wind.Direction.Localized
    }

    var windSpeedInfo: String {
        let info = self.windSpeedString + " mph " + self.windDirection
        return info
    }

    var pressure: String {
        return pressureInInchesString(inches: self.current.Pressure.Imperial.Value)
    }

    //MARK: -  Forecast panel
    func forecastInfo() -> [ForecastInfo] {
        var forecast = [ForecastInfo]()

        guard self.forecast.DailyForecasts.count > 1 else {
            return forecast
        }

        for index in 0...4 {
            let dailyInfo = self.forecast.DailyForecasts[index]

            let dowString = dowFrom(date: dailyInfo.EpochDate)
            let icon = getWeatherIconName(icon: dailyInfo.Day.Icon)
            let min = doubleToRoundedString(dbl: dailyInfo.Temperature.Minimum.Value) + degreesChar
            let max = doubleToRoundedString(dbl: dailyInfo.Temperature.Maximum.Value) + degreesChar
            forecast.append(ForecastInfo(dow: dowString, icon: icon, min: min, max: max))
            }

        return forecast
    }
}

