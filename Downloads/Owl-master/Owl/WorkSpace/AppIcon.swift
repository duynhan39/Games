//
//  AppIconSideBar.swift
//  Owl
//
//  Created by Nhan Cao on 2/22/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct AppIconMeasures {
    static var iconEdge: CGFloat = 24
    static var innerPadding: CGFloat {
        return iconEdge * 0.3
    }
    static var outterPadding: CGFloat {
        return iconEdge * 0.3
    }
    static var stokerWidth: CGFloat {
        return iconEdge * 0.1
    }
}

struct AppIcon: View {
    var appInfo: AppInfo
    var isSelected: Bool
    var body: some View {
        
        appInfo.image
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: AppIconMeasures.iconEdge, height: AppIconMeasures.iconEdge)
            .fixedSize(horizontal: true, vertical: false)
            .padding(AppIconMeasures.innerPadding)
//            .background(Color(NSColor.windowBackgroundColor))
            .background(Color.white)
            .clipShape(Circle())
            .overlay(Circle().stroke(UserPreference.appIconStrokeColor, lineWidth: AppIconMeasures.stokerWidth))
            .padding(AppIconMeasures.outterPadding)
            .saturation(isSelected ? 1.0 : 0.0)
    }
}

struct AppIconSideBar_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon(appInfo: workSpacesInfo[0].apps[0].info, isSelected: true)
    }
}

extension Color {
    public init?(hex: String) {
        let r, g, b, a: Double

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = Double((hexNumber & 0xff000000) >> 24) / 255
                    g = Double((hexNumber & 0x00ff0000) >> 16) / 255
                    b = Double((hexNumber & 0x0000ff00) >> 8) / 255
                    a = Double(hexNumber & 0x000000ff) / 255

                    self.init(RGBColorSpace.sRGB, red: r, green: g, blue: b, opacity: a)
                    return
                }
            }
        }

        return nil
    }
}
