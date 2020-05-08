//
//  AppListing.swift
//  Owl
//
//  Created by Nhan Cao on 2/22/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct SideBarAppListing: View {
    @ObservedObject var workSpace: WorkSpace
    @Binding var selectedApp: App?
    
    var delegate : ModifyableAppStack? = nil
    
    var body: some View {
        
        ScrollView {
            ForEach(workSpace.apps) { app in
                Button(action: {
                    self.delegate?.select(app: app)
                })
                {
                    AppIcon(appInfo: app.info, isSelected: self.selectedApp == app)
                }
                .buttonStyle(AppButtonStyle())
                .contextMenu {
                    Button(action: {
                        self.delegate?.close(app: app)
//                        self.workSpace.removeApp(app: app)
                    }) {
                        Text("Close")
                    }
                    Button(action: {
                        self.delegate?.remove(app: app)
                        self.workSpace.remove(app: app)
                    }) {
                        Text("Remove")
                    }
                }
            }
            Spacer()
        }
        .background(UserPreference.secondaryColor)
    }
}

struct SideBarAppListing_Previews: PreviewProvider {
    static var previews: some View {
        SideBarAppListing(workSpace: workSpacesInfo[0], selectedApp: .constant(workSpacesInfo[0].apps[0]) )
    }
}
