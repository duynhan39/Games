//
//  CustomButtonStyle.swift
//  Owl
//
//  Created by Nhan Cao on 4/5/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct ClickableRoundButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? UserPreference.selectedButtonColor : UserPreference.backgroundColor)
            .clipShape(Circle())
    }
}

//struct RoundButtonStyle: ButtonStyle {
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            
//    }
//}

