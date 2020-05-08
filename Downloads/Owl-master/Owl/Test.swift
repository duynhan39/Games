//
//  Test.swift
//  Owl
//
//  Created by Nhan Cao on 3/25/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

class Element: Hashable, Codable, Identifiable {
    //    static func == (lhs: Element, rhs: Element) -> Bool {
    //        return lhs.name == rhs.name
    //    }
    
    //    var description : String {
    //        return self.name
    //    }
    var id : Int
    var name : String
    init(id: Int, name:String) {
        self.id = id
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Element, rhs: Element) -> Bool {
        return lhs.name == rhs.name
    }
}


struct Test: View {
    
    @State var arr : [Element] = [Element(id:1, name: "A"), Element(id: 2, name: "B"), Element(id: 3, name:"C")]
    @State var signalUpdate = true
    @State var thisE : Element? = nil
//    func update(@Binding st: String) {
//        st += " |||"
//    }
    
    var body: some View {
        VStack {
            ForEach(arr.indices) { i in
                Button(action: {
//                    update(st: self.$arr[i].name)
                    self.thisE = self.arr[i]
                    self.thisE?.name = "Fucking hell"
                    print(self.arr[i].name)
//                    self.signalUpdate = !self.signalUpdate
                }) {
                    HStack {
                        Text("Name: \(self.arr[i].name)")
                        if self.signalUpdate {
                        Spacer()
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
