//
//  SpaceView.swift
//  Owl
//
//  Created by Nhan Cao on 2/22/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI
//import WebKit

struct WorkSpaceView: View {
    @Binding var workSpace: WorkSpace?
    
    @State var selectedApp : App?
    @State var appStack = [App]()
    @State var browserTabs = [App:BrowserView]()
    
    @State var showAppPicker: Bool = false

    func goBack() {
        withAnimation() {
            workSpace = nil
            selectedApp = nil
        }
    }
    
    func addApp() {
        print("Add app")
        withAnimation() {
            showAppPicker = true
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Button(action: goBack) {
                    Image(nsImage: NSImage(named: NSImage.touchBarGoDownTemplateName)!)
                }
//                .background(UserPreference.backgroundColor)
                
                SideBarAppListing(workSpace: workSpace ?? WorkSpace(), selectedApp: $selectedApp, delegate: self)
                
                Button(action: addApp) {
                    Image(nsImage: NSImage(named: NSImage.addTemplateName)!)
                }
//                .background(UserPreference.backgroundColor)
            }
            .padding(5)
            .background(UserPreference.secondaryColor)
            
            ZStack {
                ForEach(appStack) { app in
                    self.browserTabs[app]
                }
                
                if selectedApp == nil {
                    UserPreference.primaryColor
                }
            }
        }
        .popover(isPresented: self.$showAppPicker) {
//            Text("HIIIIII")
            AppPickerView(workSpace: self.$workSpace)
        }
    }
}


struct WorkSpaceNavigationDetail_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceView(workSpace: .constant(nil) , selectedApp: nil)
    }
}

protocol ModifyableAppStack {
    func select(app: App)
    func remove(app: App)
    func close(app: App)
}


extension WorkSpaceView: ModifyableAppStack {
    
    func select(app: App) {
        selectedApp = app
        if browserTabs[app] == nil {
            browserTabs[app] = BrowserView(app: app)
            appStack += [app]
        }
        appStack.swapAt(appStack.firstIndex(of: app) ?? 0, appStack.count-1)
    }
    
    func remove(app: App) {
        if (selectedApp != nil) {
            browserTabs.removeValue(forKey: app)
            appStack.removeAll { $0 == app }
        }
        
    }
    
    func close(app: App) {
        browserTabs.removeValue(forKey: app)
        if selectedApp == app {
            selectedApp = nil
        }
    }
}
