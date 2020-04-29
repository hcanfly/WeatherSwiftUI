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
    @ObservedObject var viewModel: WeatherDataViewModel

    init(viewModel: WeatherDataViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                PanelHeaderView(title: "Details")
                HStack {
                    Image(systemName: viewModel.iconName)
                        .font(.system(size: 60.0))
                        .padding(.leading, 70)
                        .padding(.trailing, 80)
                        .padding(.bottom, 20)
                    Spacer()
                    Divider()
                    VStack(spacing: 4) {
                        HStack {
                            Text("Feels like")
                                .font(.custom(panelViewFontName, size: panelViewFontSize))
                            Spacer()
                            Text(viewModel.feelsLike + degreesChar)
                                .font(.custom(panelViewFontName, size: panelViewFontSize))
                        }
                        Divider()
                        HStack {
                            Text("Humidity")
                                .font(.custom(panelViewFontName, size: panelViewFontSize))
                            Spacer()
                            Text(viewModel.feelsLike + "%")
                                .font(.custom(panelViewFontName, size: panelViewFontSize))
                        }
                        Divider()
                        HStack {
                            Text("Visibility")
                                .font(.custom(panelViewFontName, size: panelViewFontSize))
                            Spacer()
                            Text(viewModel.visibility + " mi.")
                                .font(.custom(panelViewFontName, size: panelViewFontSize))
                        }
                        Divider()
                        HStack {
                            Text("UV Index")
                                .font(.custom(panelViewFontName, size: panelViewFontSize))
                            Spacer()
                            RoundedRectangle(cornerRadius: 8, style: .circular)
                                .frame(width: 30, height: 10)
                                .foregroundColor(viewModel.uvIndexColor)
                        }.padding(.bottom, 0)
                    }.padding(.trailing, 24)
                }
                Divider()
                HStack(alignment: .top) {
                    Text(viewModel.hourlySummary)
                        .font(.custom(panelViewFontName, size: panelViewFontSize))
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
                .font(.custom(panelViewFontName, size: 26))
                .padding(.top, 20)
                .padding(.leading, 10)
            Spacer()

        }.padding(.bottom, 2)
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
        DetailsPanelView(viewModel: WeatherDataViewModel())
            .background(Color.blue)
            .frame(width: 400, height: 120)
    }
}
