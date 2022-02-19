//
//  WindAndPressureView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/18/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct WindAndPressurePanelView: View {
    let weatherData: WeatherData
    @State private var rotateLargeFan = true
     @State private var rotateSmallFan = true

    private var bladeAnimation: Animation? {
        return Animation.linear(duration: weatherData.bladeDuration).repeatForever(autoreverses: false)
    }

    // Another problem that I believe is related to the above is that when the device is rotated the blades just kind of start floating around
    // they act as if their yoffset is fairly random. I removed the yoffset modifier and tried to position differenty and this didn't make any difference
    // Everything else about layout on device rotation seems to be fine. Don't allow rotation until this gets fixed.


    var body: some View {
        VStack(alignment: .leading) {
            Group {
                PanelHeaderView(title: "Wind and Pressure")
                Spacer()
                HStack(alignment: .bottom) {
                    ZStack {
                        // Large fan
                        Image("stand_l")
                        Image("blade_big")
                            .rotationEffect(.degrees(rotateLargeFan ? 360*4 : 0))
                            .offset(y: -35)
                            // yet another really stupid SwiftUI .animate bug. Setting the animation value to rotateLargeFan won't
                            // cause the animation to draw. small blade animation below uses it to illustrate. But obviously not necessary.
                            // its use in .rotationEffect above causes the refresh
                            // but, hey I did get it to rotate, if not the way it's supposed to work
                            .animation(self.bladeAnimation)
                            .onAppear() {
                                self.rotateLargeFan.toggle()
                            }
                        }
                        ZStack {
                            // Small fan
                            Image("stand_s")
                            Image("blade_small")
                                .rotationEffect(.degrees(rotateSmallFan ? 360*4 : 0))
                                .offset(y: -25)
                                .animation(.easeIn(duration: weatherData.bladeDuration).repeatForever(autoreverses: false), value: rotateSmallFan)
                                .onAppear() {
                                    self.rotateSmallFan.toggle()
                                }
                        }
                        .offset(x: -20)
                    VStack(alignment: .leading) {
                        Text("Wind")
                         .scaledPanelFont()
                        Text(weatherData.windSpeedInfo)
                         .scaledPanelFont()
                    }.offset(y: -60)
                    VStack(alignment: .center) {
                        Text("Barometer")
                         .scaledPanelFont()
                        Text(weatherData.pressure)
                         .scaledPanelFont()
                    }.frame(width: 100)
                    .padding(.leading, 30)
                }.padding(.top, 20)
            }
        }.foregroundColor(.white)
        .background(panelBackgroundColor)
    }
}

// made an equatable imageview, which is supposed to make .animate update properly. doesn't
// equality test gets hit, but return value doesn't matter. still won't draw.
//struct BladeImageView: View, Equatable {
//    let imageName: String
//    let duration: Double
//
//    var body: some View {
//        Image(imageName)
//            .rotationEffect(.degrees(360*4))
//            .offset(y: -25)
//    }
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return false
//    }
//}
//
//struct BladeImageViewContainerView: View, Equatable {
//    let imageName: String
//    let duration: Double
//
//    var body: some View {
//        BladeImageView(imageName: imageName, duration: duration)
//            .animation(.linear(duration: duration).repeatForever(autoreverses: false))
//    }
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return false
//    }
//}
