//
//  ForecastPanelView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct ForecastPanelView: View {
    var dailyWeather: [DailyWeatherViewModel]

    var body: some View {
        Group {
        if (dailyWeather.count > 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Group {
                        PanelHeaderView(title: "Forecast")
                            .padding(.bottom, 10)
                        ForEach((0...4), id: \.self) {
                            ForecastDayView(dailyWeather: self.dailyWeather[$0])
                        }
                    }
                    .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                .background(Image("PanelBackground").resizable())
            } else {
                VStack {
                    Text("No data")
                }
                .padding(.bottom, 10)
                .background(panelBackgroundColor)

            }
        }
    }
}

struct ForecastDayView: View {
    var dailyWeather: DailyWeatherViewModel

    var body: some View {
        HStack {
            Text(dailyWeather.dayOfWeek)
                .font(.custom(panelViewFontName, size: panelViewFontSize))
                .frame(width: 110, alignment: .leading)
            Spacer()
            Image(systemName: dailyWeather.iconName)
            Spacer()
            Text(dailyWeather.highTemperature + degreesChar)
                .font(.custom(panelViewFontName, size: panelViewFontSize))
            Text(dailyWeather.lowTemperature + degreesChar)
                .font(.custom(panelViewFontName, size: panelViewFontSize))
        }.padding(.leading, 20)
        .padding(.trailing, 20)
    }
}


//struct ForecastPanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.blue
//            ForecastPanelView(dailyWeather: [])
//        }
//    }
//}
