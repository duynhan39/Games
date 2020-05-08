//
//  HeaderView.swift
//  Owl
//
//  Created by Nhan Cao on 4/29/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI
import Resolver

struct HeaderView: View {
    @ObservedObject var data = _userData
    
    @State var showPopOver = false
    
    @Injected var authenticationService: AuthenticationService
    
    func openSetting() {
        showPopOver = true
    }
    
    func signout() {
        do {
            try authenticationService.signOut()
        } catch {
            // do nothing
        }
    }
    
    func editProfile() {
        
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hi \(data.firstName)")
                    .font(.custom("Times New Roman", size: 50))
                
                Text("What do you want to work on today?")
                    .font(.custom("Times New Roman", size: 30))
            }.padding()
            Spacer()
            
            Button(action: openSetting) {
                //                Image(nsImage: NSImage(named: NSImage.touchBarGetInfoTemplateName)!)
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(AppButtonStyle())
            .padding()
            .popover(isPresented: self.$showPopOver) {
                VStack {
                    Button(action: self.editProfile) {
                        //                Image(nsImage: NSImage(named: NSImage.touchBarGetInfoTemplateName)!)
                        Text("Edit info")
                            .padding()
                    }
                    Button(action: self.signout) {
                        //                Image(nsImage: NSImage(named: NSImage.touchBarGetInfoTemplateName)!)
                        Text("Sign out")
                            .padding()
                            .foregroundColor(Color.red)
                    }
                }
            }
        }
    }
    
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
