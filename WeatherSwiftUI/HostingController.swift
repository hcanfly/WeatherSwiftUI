//
//  HostingController.swift
//  WeatherSwiftUI
//
//  Created by Gary on 6/2/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//


import SwiftUI

final class HostingController<T: View>: UIHostingController<T> {
    // out background is pretty dark. set the status bar text color to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
