//
//  ViewModel+Network.swift
//  WeatherSwiftUI
//
//  Created by Gary on 6/1/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation


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

    static var hourlyForecastWeather: URL? {
        URL(string: "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/\(locationCode)?apikey=\(accuWeatherapikey)&details=false")
    }

}

extension ViewModel {
    
    // can't make func async because initial view gets disposed before func finishes and calls get cancelled.
    // and we really just want async, not await anyhow. don't want to wait for a response. state will be updated when we get a response.
    func getWeather() {
        
        self.state = .loading
        
        Task {
            do {
                let currentWeather = try await DataFetcher.fetch(url: URL.weather, myType: [CurrentData].self)
                let forecastWeather = try await DataFetcher.fetch(url: URL.forecastWeather, myType: ForecastData.self)
                
                self.weatherData.forecast = forecastWeather
                self.weatherData.current = currentWeather.first!
                DispatchQueue.main.async {
                    self.state = .loaded(self.weatherData)
                }
                
            } catch (let error) {
                print(error.localizedDescription)
                self.state = .failed(error as! NetworkError)
            }
        }
        
    }
}
// Combine
//extension ViewModel {
//
//    func getWeather() {
//
//        self.state = .loading
//        let currentWeatherPublisher = DataFetcher.fetch(url: URL.weather, myType: [CurrentData].self)
//        let forecastWeatherPublisher = DataFetcher.fetch(url: URL.forecastWeather, myType: ForecastData.self)
//
//        // wait until both fetches finish before updating the data and forcing the UI to refresh
//        let _ = Publishers.Zip(currentWeatherPublisher, forecastWeatherPublisher)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let theError):
//                    self.handleDownloadError(error: theError)
//                    self.state = .failed(theError)
//                }
//            }, receiveValue: { (current, forecast) in
//                if current.count > 0 {
//                    self.weatherData.current = current.first!
//                    self.weatherData.forecast = forecast
//                    self.state = .loaded(self.weatherData)
//                } else {
//                    self.handleDownloadError(error: .invalidServerResponse)
//                    self.state = .failed(.invalidServerResponse)
//                }
//            }
//            )
//            .store(in: &disposables)
//    }
//
//    // in real life you might want a bit more than this...
//    func handleDownloadError(error: NetworkError) {
//        switch error {
//        case NetworkError.invalidHTTPResponse:
//            //print(error.errorDescription)
//            break
//        case NetworkError.invalidServerResponse:
//            //print(error.errorDescription)
//            break
//        case NetworkError.jsonParsingError:
//            //print(error.errorDescription)
//            break
//        default:
//            break
//        }
//    }
//
//}
