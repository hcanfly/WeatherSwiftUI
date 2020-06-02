//
//  NetworkWeather.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation
import Combine



enum NetworkError: Error, LocalizedError {
    case unknown, apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        }
    }
}


enum DataFetcher {

    // download data and decode from JSON
    static func fetch<T: Decodable>(url: URL?, myType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = url else {
          fatalError("Did you enter your AccuWeather API Key?")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { data, response -> Data in
              guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                  throw NetworkError.unknown
              }
              //print(String(bytes: data, encoding: String.Encoding.utf8))
              return data
          }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

}
