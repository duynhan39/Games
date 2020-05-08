//
//  ContentView.swift
//  Owl
//
//  Created by Nhan Cao on 4/27/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI
import Resolver

struct ContentView: View {
    @ObservedObject var authenticationService: AuthenticationService = Resolver.resolve()
    
    @State var isBoosting = true
    
    var body: some View {
        Group {
            
            //        HStack {
            //            LoginView()
            if (isBoosting) {
                Splash()
            } else
                if (authenticationService.user != nil) {
                    MainMenu()
                } else {
                    LoginView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              withAnimation() {
                self.isBoosting = false
              }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
