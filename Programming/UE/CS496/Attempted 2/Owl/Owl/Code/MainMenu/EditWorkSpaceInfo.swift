//
//  EditWorkSpaceInfo.swift
//  Owl
//
//  Created by Nhan Cao on 4/12/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct EditWorkSpaceInfo: View {
    var workSpace : WorkSpace
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var title:String=""
    @State var description:String=""
    
    //    init(workSpace: WorkSpace) {
    //        print(workSpace)
    //        print(workSpace.title)
    //        print(workSpace.description)
    //
    //        self.workSpace = workSpace
    //        title = workSpace.title
    //        description = workSpace.description
    //    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func cancel() {
        dismiss()
    }
    
    func save() {
        workSpace.title = title
        workSpace.description = description
        DataManager.save(option: DataFile.workSpace)
        dismiss()
    }
    
    func delete() {
        _userData.remove(workSpace: workSpace)
        DataManager.save(option: DataFile.workSpace)
        dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edit Work Space")
                .font(.custom("Times New Roman", size: 20))
            
            Text("Title")
            TextField("Work accounts", text: $title)
                .onAppear{
                    self.title = self.workSpace.title
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Description")
            TextField("Work stuff", text: $description)
                .onAppear{
                    self.description = self.workSpace.description
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack(spacing: 12) {
                Button(action: delete) {
                    Text("Delete")//.frame(width:50)
                        .foregroundColor(Color.red)
                }
//                .accent
                Spacer()
                Button(action: cancel) {
                    Text("Cancel")//.frame(width:70)
                }
                Button(action: save){
                    Text("Save")//.frame(width:70)
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
            }
        }
        .padding()
        .background(UserPreference.backgroundColor)
        .frame(width: 400)
        
    }
}

struct EditWorkSpaceInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkSpaceInfo(workSpace: workSpacesInfo[0])
    }
}
