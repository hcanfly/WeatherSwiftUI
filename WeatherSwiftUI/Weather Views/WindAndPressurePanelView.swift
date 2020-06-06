//
//  WindAndPressureView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/18/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct WindAndPressurePanelView: View {
    @ObservedObject var viewModel: ViewModel

    var bladeAnimation: Animation? {
        // duration / repeatForever is seriously broken. this animation will never change even though it gets called with new model values
        // so, this should work because it gets called when model changes - but it doesn't work
        // I'm not the first to find this bug.
        return viewModel.bladeDuration < 80 ? Animation.linear(duration: viewModel.bladeDuration).repeatForever(autoreverses: false) : nil
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
                         .scaledPanelFont()
                        Text(viewModel.windSpeedInfo)
                         .scaledPanelFont()
                    }.offset(y: -60)
                    VStack(alignment: .center) {
                        Text("Barometer")
                         .scaledPanelFont()
                        Text(viewModel.pressure)
                         .scaledPanelFont()
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
            WindAndPressurePanelView(viewModel: ViewModel())
        }
        .frame(width: 400, height: 120)
    }
}


