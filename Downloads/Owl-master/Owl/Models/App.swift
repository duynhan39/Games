//
//  App.swift
//  Owl
//
//  Created by Nhan Cao on 3/30/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import Foundation
import SwiftUI

final class App{
    
    var id: Int
    var name: String
    
    var info: AppInfo {
        return appsInfo[name] ?? AppInfo()
    }
    
    convenience init(app: AppInfo, id: Int) {
        self.init(appName: app.name, id: id)
    }
    
    init(appName name: String, id: Int) {
        self.id = id
        self.name = name
    }
}

extension App: Hashable, Codable, Identifiable {
    static func == (lhs: App, rhs: App) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}


