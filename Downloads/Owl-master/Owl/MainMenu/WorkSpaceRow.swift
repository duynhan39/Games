//
//  SpaceInfoView.swift
//  Owl
//
//  Created by Nhan Cao on 2/22/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct WorkSpaceRow: View {
    var space: WorkSpace
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var showEditWorkSpace: Bool = false
    
    func edit() {
        showEditWorkSpace = true
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(space.title)
                    .fontWeight(.bold)
                    .truncationMode(.tail)
                    .frame(minWidth: 20)
                    .foregroundColor(UserPreference.textColor)
                    
                Text(space.description)
                    .font(.caption)
                    .opacity(0.625)
                    .truncationMode(.middle)
                    .frame(minWidth: 20)
                    .foregroundColor(UserPreference.textColor)
            }
            Spacer()
            
            Button(action: edit) {
                Image(nsImage: NSImage(named: NSImage.touchBarGetInfoTemplateName)!)
            }
            .buttonStyle(AppButtonStyle())
        }
        .padding()
        .background(UserPreference.backgroundColor)
        .cornerRadius(4)
        .shadow(color: UserPreference.textColor.opacity(colorScheme == .light ? 0.4 : 0), radius: 2, x: 2, y: 2)
        .popover(isPresented: self.$showEditWorkSpace) {
            EditWorkSpaceInfo(workSpace: self.space)
        }
    }
}

struct SpaceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        WorkSpaceRow(space: workSpacesInfo[1])
    }
}
