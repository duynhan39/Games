//
//  AddAnApp.swift
//  Owl
//
//  Created by Nhan Cao on 3/13/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct AppPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
//    @State var selections : [Int] = [0,1,2,3,4]
    @Binding var workSpace : WorkSpace?
    @Binding var showing : Bool
    
    let data = workSpacesInfo
    
    let buttonWidth: CGFloat = 100
    
    func dismiss() {
//        self.presentationMode.wrappedValue.dismiss()
        showing = false
    }
    
    func cancel() {
        print("Cancel")
        dismiss()
    }
    
    func selectApp(appInfo : AppInfo) {
        workSpace?.add(with: appInfo)
        dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Add a new app to your current Work Space")
                .padding()
            
            ScrollView {
                Grid(appsInfoArray) { appInfo in
                    Button(action: {
                        self.selectApp(appInfo: appInfo)
                    })
                    {
                        VStack {
                            AppIcon(appInfo: appInfo, isSelected: true)
                            Text(appInfo.officialName)
                                .foregroundColor(UserPreference.textColor)
                        }
                    }.buttonStyle(AppButtonStyle())
                }
                
            }.gridStyle(
                ModularGridStyle(columns: .min(100), rows: .fixed(100))
            )
            
            Button(action: cancel) {
                Text("Cancel")//.frame(width:50)
            }.padding()
            
        }.frame(width: 600, height: 450)
            .background(UserPreference.backgroundColor)
    }
}

struct AddAnApp_Previews: PreviewProvider {
    static var previews: some View {
        AppPickerView(workSpace: .constant(workSpacesInfo[0]), showing: .constant(true))
    }
}

