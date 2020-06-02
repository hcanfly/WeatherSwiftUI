//
//  ForecastPanelView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct ForecastPanelView: View {
    let forecast: [ForecastInfo]


    var body: some View {
        Group {
        if (forecast.count > 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Group {
                        PanelHeaderView(title: "Forecast")
                            .padding(.bottom, 10)
                        ForEach((0...4), id: \.self) {
                            ForecastDayView(dailyWeather: self.forecast[$0])
                        }
                    }
                    .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                .background(panelBackgroundColor)
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
    var dailyWeather:  ForecastInfo

    var body: some View {
        HStack {
            Text(dailyWeather.dow)
                .scaledPanelFont()
                .frame(width: 110, alignment: .leading)
            Spacer()
            Image(dailyWeather.icon)
            Spacer()
            Text(dailyWeather.max + degreesChar)
                .scaledPanelFont()
            Text(dailyWeather.min + degreesChar)
                .scaledPanelFont()
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
