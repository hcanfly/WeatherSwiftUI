//
//  WindAndPressureView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/18/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct WindAndPressurePanelView: View {
    @ObservedObject var viewModel: WeatherDataViewModel

    init(viewModel: WeatherDataViewModel) {
      self.viewModel = viewModel
    }

    var bladeAnimation: Animation {
        // duration / repeatForever is seriously broken. this animation will never change even though it gets called with new model values
        // so, this should work because it gets called when model changes - but it doesn't work
        // I'm not the first to find this bug.
        return Animation.linear(duration: viewModel.bladeDuration).repeatForever(autoreverses: false)
    }

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
                         .font(.custom(panelViewFontName, size: panelViewFontSize))
                        Text(viewModel.windSpeed + " mph " + viewModel.windDirection)
                         .font(.custom(panelViewFontName, size: panelViewFontSize))
                    }.offset(y: -60)
                    VStack(alignment: .center) {
                        Text("Barometer")
                         .font(.custom(panelViewFontName, size: panelViewFontSize))
                        Text(viewModel.barometer + " in")
                         .font(.custom(panelViewFontName, size: panelViewFontSize))
                    }.frame(width: 100)
                    .padding(.leading, 30)
                }.padding(.top, 20)
            }
        }.foregroundColor(.white)
        .background(panelBackgroundColor)
    }
}


struct WindAndPressureView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
            WindAndPressurePanelView(viewModel: WeatherDataViewModel())
        }
        .frame(width: 400, height: 120)
    }
}

