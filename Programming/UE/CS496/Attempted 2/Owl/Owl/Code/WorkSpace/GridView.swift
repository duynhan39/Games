//
//  GridView.swift
//  Owl
//
//  Created by Nhan Cao on 3/14/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI

struct GridView: View {
    var content : [Any]
    var body: some View {
        GeometryReader { geometry in
            Color.blue
        }

    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(content: [Any]())
    }
}

