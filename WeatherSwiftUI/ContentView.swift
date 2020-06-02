//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var scrollViewOffset: CGPoint = .zero

    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let panelWidth = UIScreen.main.bounds.width - 20
    let panelHeight: CGFloat = 120

    let cityName = "Mountain View"


    func calcBlurRadius() -> CGFloat {
        // blur the background image more as view is scrolled down
        let blur = CGFloat((-self.scrollViewOffset.y / (screenHeight * 0.7)) * 15.0)
        return blur
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("BlueSky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // need frame to constrain geometry bounds on some devices
                    .frame(width: self.screenWidth, height: self.screenHeight)
                    .blur(radius: self.calcBlurRadius())
                // 11 Pro Max Geometry says we are getting bounds wider than the screen. Looks like this comes from presence of background image
                HStack(alignment: .center) {
                    Text(self.cityName)
                        .font(.title)
                        .foregroundColor(.white)
                }.offset(y: 40)
                OffsetScrollView(.vertical, showsIndicators: false, offset: self.$scrollViewOffset) {
                        VStack(alignment: .center, spacing: 90) {
                            CurrentWeatherView(viewModel: self.viewModel)
                                .frame(width: self.panelWidth, height: self.panelHeight)
                            DetailsPanelView(viewModel: self.viewModel)
                                .frame(width: self.panelWidth, height: self.panelHeight)
                                .padding(.bottom, 60)
                            ForecastPanelView(forecast:self.viewModel.forecastInfo())
                                .frame(width: self.panelWidth, height: self.panelHeight)
                            .padding(.bottom, 60)
                            WindAndPressurePanelView(viewModel: self.viewModel)
                                .frame(width: self.panelWidth, height: self.panelHeight)
                            Spacer()
                        }.padding(.top, self.screenHeight - geometry.safeAreaInsets.bottom - 190)
                    }
                .frame(width: self.panelWidth)
                    .offset(y: geometry.safeAreaInsets.top + 10)
                }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.viewModel.getWeather()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.viewModel.getWeather()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
