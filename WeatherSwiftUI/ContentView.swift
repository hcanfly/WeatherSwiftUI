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
    @Environment(\.scenePhase) var scenePhase

    let panelHeight: CGFloat = 120

    let cityName = "Mountain View"


    func calcBlurRadius(height: CGFloat) -> CGFloat {
        // blur the background image more as view is scrolled down
        let blur = CGFloat((-self.scrollViewOffset.y / (height * 0.7)) * 15.0)
        return blur
    }

    var body: some View {
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
                        CurrentWeatherView(viewModel: self.viewModel)
                            .frame(width: geometry.size.width, height: panelHeight)
                        DetailsPanelView(viewModel: self.viewModel)
                            .frame(width: geometry.size.width, height: panelHeight)
                            .padding(.bottom, 60)
                        ForecastPanelView(forecast:self.viewModel.forecastInfo())
                            .frame(width: geometry.size.width, height: panelHeight)
                            .padding(.bottom, 60)
                        WindAndPressurePanelView(viewModel: self.viewModel)
                            .frame(width: geometry.size.width, height: panelHeight)
                        Spacer()
                    }.padding(.top, geometry.size.height - geometry.safeAreaInsets.bottom - 230)
                }
                .frame(width: geometry.size.width)
                .offset(y: geometry.safeAreaInsets.top + 54)
            }
        }
        //.edgesIgnoringSafeArea(.all)          //TODO: deprecated in Xcode 12.
        .ignoresSafeArea(.all)
        .onAppear {
            self.viewModel.getWeather()
        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//            self.viewModel.getWeather()
//        }
        .onChange(of: scenePhase) { phase in      // iOS 14 replacement for notification
            if phase == .active {
              self.viewModel.getWeather()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
