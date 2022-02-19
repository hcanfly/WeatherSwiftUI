//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var scrollViewOffset: CGPoint = .zero
    @Environment(\.scenePhase) var scenePhase
    
    private let panelHeight: CGFloat = 120
    private let cityName = "Mountain View"
    
    
    func calcBlurRadius(height: CGFloat) -> CGFloat {
        // blur the background image more as view is scrolled down
        let blur = CGFloat((-self.scrollViewOffset.y / (height * 0.7)) * 15.0)
        return blur
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Color.clear.onAppear(perform: viewModel.getWeather)
        case .loading:
            ProgressView()
        case .failed(let error):
            Text("Error: \(error.errorDescription)")
        case .loaded(let weatherData):
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Image("BlueSky")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    // need frame to constrain geometry bounds on some devices
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: self.calcBlurRadius(height: geometry.size.height))
                    HStack(alignment: .center) {
                        Text(self.cityName)
                            .font(.title)
                            .foregroundColor(.white)
                    }.offset(y: 40)
                    OffsetScrollView(.vertical, showsIndicators: false, offset: self.$scrollViewOffset) {
                        VStack(alignment: .center, spacing: 90) {
                            CurrentWeatherView(weatherData: weatherData)
                                .frame(width: geometry.size.width, height: panelHeight)
                            DetailsPanelView(weatherData: weatherData)
                                .frame(width: geometry.size.width, height: panelHeight)
                                .padding(.bottom, 60)
                            ForecastPanelView(forecast:weatherData.forecastInfo())
                                .frame(width: geometry.size.width, height: panelHeight)
                                .padding(.bottom, 60)
                            WindAndPressurePanelView(weatherData: weatherData)
                                .frame(width: geometry.size.width, height: panelHeight)
                                .padding(.bottom, 20)
                            Spacer()
                        }.padding(.top, geometry.size.height - geometry.safeAreaInsets.bottom - 230)
                    }
                    .frame(width: geometry.size.width)
                    .offset(y: geometry.safeAreaInsets.top + 74)
                }
            }
            .ignoresSafeArea()
            // this isn't working. it should work. did for a while
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    viewModel.getWeather()
                }
            }
        }
        
    }
}
