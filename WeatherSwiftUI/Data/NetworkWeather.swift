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


final class DataFetcher {

    // download data and decode from JSON
    func fetch<T: Decodable>(urlString: String, myType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            let error = NetworkError.apiError(reason: "Couldn't create URL")

        return Fail(error: error).eraseToAnyPublisher()
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
