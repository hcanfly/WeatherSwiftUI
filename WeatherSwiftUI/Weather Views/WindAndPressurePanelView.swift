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

    private var bladeAnimation: Animation? {
        // duration / repeatForever is seriously broken. this animation will never change even though it gets called with new model values
        // so, this should work because it gets called when model changes - but it doesn't work
        // and setting the duration to a default number instead of returning nil animation was tried first. didn't work either.
        // also tried making this a function call instead of a var.
        // I'm not the first to find this bug. Been checking on this for a couple of years now.

        return Animation.linear(duration: weatherData.bladeDuration).repeatForever(autoreverses: false)
    }

    // Another problem that I believe is related to the above is that when the device is rotated the blades just kind of start floating around
    // they act as if their yoffset is fairly random. I removed the yoffset modifier and tried to position differenty and this didn't make any difference
    // Everything else about layout on device rotation seems to be fine. Don't allow rotation until this gets fixed.


    @State private var rotateLargeFan = true
    @State private var rotateSmallFan = true

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
                                .animation(self.bladeAnimation)
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



