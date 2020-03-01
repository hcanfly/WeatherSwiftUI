//
//  CurrentWeatherView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI

let panelViewFontName = "Helvetica Neue"


struct CurrentWeatherView: View {
    @ObservedObject var viewModel: WeatherDataViewModel
    let currentWeatherViewFontSize: CGFloat = 24

    init(viewModel: WeatherDataViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Image(systemName: viewModel.iconName)
                        .font(.system(size: currentWeatherViewFontSize))
                    Text(viewModel.summary)
                        .font(.custom(panelViewFontName, size: currentWeatherViewFontSize))
                        .padding(.top, 5)
                }
                HStack {
                    Image("HighTemp")
                        .resizable()
                        .frame(width: 13, height: 17)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 8)
                    Text(viewModel.highTemperature + degreesChar)
                        .font(.custom(panelViewFontName, size: currentWeatherViewFontSize))
                        .padding(.trailing, currentWeatherViewFontSize)
                    Image("LowTemp")
                        .resizable()
                        .frame(width: 13, height: 17)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 8)
                    Text(viewModel.lowTemperature + degreesChar)
                        .font(.custom(panelViewFontName, size: currentWeatherViewFontSize))
                        .padding(.trailing, currentWeatherViewFontSize)
                    Spacer()
                }
                HStack {
                    Text(viewModel.temperature + degreesChar)
                        .font(.custom(panelViewFontName, size: 50))
                }
            }.foregroundColor(.white)
        } .padding(.leading, 20)
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(viewModel: WeatherDataViewModel())
            .background(Color.blue)
    }
}
