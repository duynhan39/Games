//
//  AddWorkSpaceView.swift
//  Owl
//
//  Created by Nhan Cao on 4/5/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct AddWorkSpaceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var workSpaces:[WorkSpace]
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func cancel() {
        print("Canceled")
        dismiss()
    }
    
    func save() {
//        print("Saved")
        
        let newWorkSpace = WorkSpace(title: title, description: description)
        _userData.add(workSpace: newWorkSpace)
        DataManager.save(option: DataFile.workSpace)
        dismiss()
    }
    
    @State var title:String = ""
    @State var description:String = ""
    

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add a new Work Space")
            .font(.custom("Times New Roman", size: 20))
            
            Text("Title")
            TextField("Work accounts", text: $title)
            Text("Description")
            TextField("Work stuff", text: $description)
            
            HStack(spacing: 12) {
                Spacer()
                Button(action: cancel) {
                    Text("Cancel").frame(width:50)
                }
                Button(action: save){
                    Text("Save").frame(width:50)
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            }
        }
        .padding()
        .background(UserPreference.backgroundColor)
        .frame(width: 400)
        
    }
}

struct AddWorkSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkSpaceView(workSpaces: workSpacesInfo)
            //.constant(workSpacesInfo))
    }
}
