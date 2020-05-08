//
//  SpaceListView.swift
//  Owl
//
//  Created by Nhan Cao on 2/22/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct WorkSpaceList: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        List {
            ForEach(userData.spaces) { space in
                WorkSpaceRow(space: space)
            }
        }
//        .navigationBarTitle("Spaces")
        
    }
}

struct SpaceListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceList()
            .environmentObject(UserData())
    }
}
