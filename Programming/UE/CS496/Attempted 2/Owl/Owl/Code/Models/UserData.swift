//
//  UserData.swift
//  Owl
//
//  Created by Nhan Cao on 2/22/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import Combine
import SwiftUI

//final class UserData: ObservableObject {
//    @Published var allSpaces = workSpacesInfo
//    @Published var allApps = appsInfo
//}

class UserData: ObservableObject, Codable {
    
    var userID:Int = 0
    
    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var workSpaces:[WorkSpace] = []
    
    var appIDCounter:Int = 0
    var workSpaceIDCounter:Int = 0
    
    enum CodingKeys: CodingKey {
        case firstName, lastName, userID, workSpaces, appIDCounter, workSpaceIDCounter
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.workSpaces = try container.decode(Array<WorkSpace>.self, forKey: .workSpaces)
        self.appIDCounter = try container.decode(Int.self, forKey: .appIDCounter)
        self.workSpaceIDCounter = try container.decode(Int.self, forKey: .workSpaceIDCounter)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(userID, forKey: .userID)
        try container.encode(workSpaces, forKey: .workSpaces)
        try container.encode(appIDCounter, forKey: .appIDCounter)
        try container.encode(workSpaceIDCounter, forKey: .workSpaceIDCounter)
    }
    
    init() {
        
    }

    
}

extension UserData: Hashable, Identifiable {
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        return lhs.userID == rhs.userID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
}

extension UserData {
    func add(workSpace:WorkSpace) {
        self.workSpaces += [workSpace]
    }
    
    func remove(workSpace:WorkSpace) {
        self.workSpaces.removeAll{$0 == workSpace}
    }
}
