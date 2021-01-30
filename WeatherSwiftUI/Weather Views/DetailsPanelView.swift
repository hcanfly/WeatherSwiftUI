//
//  DetailsView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI

let panelViewFontSize: CGFloat = 16
let panelBackgroundColor = Color(UIColor(hex: 0x000049, alpha: 0.1))

struct DetailsPanelView: View {
    @ObservedObject var viewModel: ViewModel
    private let screenWidth = UIScreen.main.bounds.width


    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                PanelHeaderView(title: "Details")
                    .padding(.leading, screenWidth > 500 ? 0 : 14)
                HStack {
                    Image(viewModel.weatherIconName)
                        .font(.system(size: 60.0))
                        .padding(.leading, 70)
                        .padding(.trailing, 80)
                        .padding(.bottom, 20)
                    Spacer()
                    Divider()
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            Text("Feels like")
                                .scaledPanelFont()
                                .alignmentGuide(HorizontalAlignment.center, computeValue: { _ in -190 } )
                            Spacer()
                            Text(viewModel.feelsLike)
                                .scaledPanelFont()
                        }
                        Divider()
                        HStack {
                            Text("Humidity")
                                .scaledPanelFont()
                            Spacer()
                            Text(viewModel.humidity)
                                .scaledPanelFont()
                        }
                        Divider()
                        HStack {
                            Text("Visibility")
                                .scaledPanelFont()
                            Spacer()
                            Text(viewModel.visibility)
                                .scaledPanelFont()
                        }
                        Divider()
                        HStack {
                            Text("UV Index")
                                .scaledPanelFont()
                            Spacer()
                            RoundedRectangle(cornerRadius: 8, style: .circular)
                                .frame(width: 30, height: 10)
                                .foregroundColor(viewModel.uvIndexColor)
                        }.padding(.bottom, 0)
                    }.padding(.trailing, screenWidth > 500 ? 20 : 36)
                    .frame(width: 180)
                }
                Spacer()
            }.foregroundColor(.white)
        }.background(panelBackgroundColor)
    }
}

struct PanelHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .scaledPanelFont(size: 26)
                .padding(.top, 20)
                .padding(.leading, 10)
            Spacer()

        }.padding(.bottom, 2)
    }
}

extension View {

    func scaledPanelFont(size: CGFloat = panelViewFontSize) -> some View {
        return self.modifier(ScaledFont(name: panelViewFontName, size: size))
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha )
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsPanelView(viewModel: ViewModel())
            .background(Color.blue)
            .frame(width: 400, height: 120)
    }
}
