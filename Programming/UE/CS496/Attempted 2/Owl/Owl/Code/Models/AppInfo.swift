//
//  App.swift
//  Owl
//
//  Created by Nhan Cao on 2/22/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import Foundation
import SwiftUI

final class AppInfo {
    
    var id: Int
    var name: String
    var officialName: String
    var url: String
    
    init() {
        id = 0
        name = ""
        officialName = ""
        url = ""
    }
}

extension AppInfo: Hashable, Codable, Identifiable {
    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

extension AppInfo {
    var image: Image {
        ImageStore.shared.image(name: name)
    }
}

