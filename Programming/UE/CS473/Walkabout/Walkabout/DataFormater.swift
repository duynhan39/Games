//
//  CheckPoint.swift
//  Walkabout
//
//  Created by Nhan Cao on 10/28/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import Foundation
import UIKit

class DataFormater {
    enum DataType: Int {
        case time, distance, speed
    }
    
    static func getDisplayTime(of time: Double) -> (String, String, Double) {
        var timeText : String
        var timeUnitText : String
        var displayedNumber : Double = 0
        var timerUpdateInterval : Double = 0
        
        switch time {
        case 0...60:
            timeUnitText = "sec"
            timerUpdateInterval = 0.1
            displayedNumber = time
        case 60..<3600:
            timeUnitText = "min"
            timerUpdateInterval = 6
            displayedNumber = time/60
        case 3600..<3600*24:
            timeUnitText = "hr"
            timerUpdateInterval = 360
            displayedNumber = time/3600
        case (3600*24)...:
            timeUnitText = "day"
            timerUpdateInterval = 360*24
            displayedNumber = time/(3600*24)
        default:
            timeUnitText = "sec"
            timerUpdateInterval = -1
            displayedNumber = 0
        }
        
        timeText = String(format: "%.1f", displayedNumber)
        return (timeText, timeUnitText, timerUpdateInterval)
    }
    
    static func getDisplayDistance(of distance: Double) -> (String, String) {
        var distanceText : String
        var distanceUnitText : String
        var displayedNumber : Double = 0
        
        switch distance {
        case 0..<1000:
            displayedNumber = distance
            distanceUnitText = "m"
        default:
            displayedNumber = distance / 1000
            distanceUnitText = "km"
        }
        
        distanceText = String(format: "%.1f", displayedNumber)
        if distanceText.count > 5 {
            distanceText = String(format: "%.1f", displayedNumber/1000) + "k"
        }
        
        return (distanceText, distanceUnitText)
    }
    
    static func getDisplaySpeed(of speed: Double) -> (String, String) {
        var speedText : String
        var speedUnitText : String
        var displayedNumber : Double = 0
        
        displayedNumber = speed / 3.6
        speedUnitText = "km/hr"
        
        speedText = String(format: "%.1f", displayedNumber)
        if speedText.count > 5 {
            speedText = String(format: "%.1f", displayedNumber/1000) + "k"
        }
        return (speedText, speedUnitText)
    }
    
    
}


