//
//  ViewModel+Network.swift
//  WeatherSwiftUI
//
//  Created by Gary on 6/1/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation
import Combine


/*
    You need a AccuWeather API key which you can get a free low-use key here: https://developer.accuweather.com/getting-started (start with Register button at the top of the screen)

    You can find location codes a number of ways here: https://developer.accuweather.com/accuweather-locations-api/apis
 */


let locationCode = "337169"         // Mountain View, CA
let accuWeatherapikey = "<your AccuWeather api key>"  // <your AccuWeather api key>

extension URL {

    static var weather: URL? {
        URL(string: "https://dataservice.accuweather.com/currentconditions/v1/\(locationCode)?apikey=\(accuWeatherapikey)&details=true")
    }

    static var forecastWeather: URL? {
        URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(locationCode)?apikey=\(accuWeatherapikey)&details=true")
    }

}

extension ViewModel {

    func getWeather() {

        let currentWeatherPublisher = URLSession.shared.dataTaskPublisher(for: URL.weather!)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.unknown
                }
                //print(String(bytes: data, encoding: String.Encoding.utf8))
                return data
        }
        .decode(type: [CurrentData].self, decoder: JSONDecoder())
        .replaceError(with: [])
        .eraseToAnyPublisher()

        let forecastWeatherPublisher = URLSession.shared.dataTaskPublisher(for: URL.forecastWeather!)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.unknown
                }
                //print(String(bytes: data, encoding: String.Encoding.utf8))
                return data
        }
        .decode(type: ForecastData.self, decoder: JSONDecoder())
        .replaceError(with: self.forecast)      // yes, hack. but shouldn't happen. not recommended for real app.
        .eraseToAnyPublisher()

        let _ = Publishers.Zip(currentWeatherPublisher, forecastWeatherPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { current, forecast in
                self.current = current[0]
                self.forecast = forecast
            })
            .store(in: &disposables)
    }
}


