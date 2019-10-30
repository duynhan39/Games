//
//  CheckPoint.swift
//  Walkabout
//
//  Created by Nhan Cao on 10/28/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import Foundation
import CoreLocation

class CheckPoint {
    var location: CLLocation
    var timeStamp: Date
    
    init(location: CLLocation, timeStamp: Date) {
        self.location = location
        self.timeStamp = timeStamp
    }
    
    convenience init(location: CLLocation) {
        self.init(location: location, timeStamp: Date())
    }
    
    convenience init(){
        self.init(location: CLLocation(), timeStamp: Date())
    }
    
    static func averageSpeed(of points: [CheckPoint]) -> Double? {
        if points.count < 2 { return nil }
        
        var distanceInMeter: Double = 0
        for i in 1..<points.count {
            distanceInMeter += points[i].location.distance(from: points[i-1].location)
        }
        
        let timeIntervalInSec = points.last!.timeStamp.timeIntervalSince(points.first!.timeStamp)
        
        return distanceInMeter/timeIntervalInSec
    }
    
    static func instantaneousSpeed(between points: [CheckPoint]) -> [Double]? {
        if points.count < 2 { return nil }
        
        var instantaneousSpeeds = [Double]()
        
        for i in 1..<points.count {
            let distanceInMeter = points[i].location.distance(from: points[i-1].location)
            let timeIntervalInSec = points[i].timeStamp.timeIntervalSince(points[i-1].timeStamp)
            
            instantaneousSpeeds += [distanceInMeter/timeIntervalInSec]
        }
        
        return instantaneousSpeeds
    }
}
