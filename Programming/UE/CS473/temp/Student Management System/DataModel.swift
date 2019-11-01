//
//  DataModel.swift
//  Student Management System
//
//  Created by Nhan Cao on 10/12/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import Foundation
import CoreData

class DataModel {
    enum ObjectType: String, CustomStringConvertible {
        var description: String {
            return self.rawValue
        }
        case student = "Student"
        case professor = "Professor"
        case course = "Course"
        
        static var all = [DataModel.ObjectType.student, .professor, .course]
    }
    
}

extension Student {
    override public var description: String {
        return "\(self.firstName ?? "") \(self.lastName ?? "")"
    }
}

extension Professor {
    override public var description: String {
        return "\(self.firstName ?? "") \(self.lastName ?? "")"
    }
}

extension Course {
    override public var description: String {
        var des = "\(self.departmentCode ?? "")\(self.number ?? "")"
        if self.name != nil && self.name != "" {
            des += " - \(self.name!)"
        }
        return des
    }
}


