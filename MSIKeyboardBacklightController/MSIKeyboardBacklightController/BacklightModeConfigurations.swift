//
//  BacklightModes.swift
//  MSIKeyboardBacklightController
//
//  Created by Rostyslav Dovhaliuk on 8/2/15.
//  Copyright © 2015 Rostyslav Dovhaliuk. All rights reserved.
//

import Foundation

enum BacklightModeType: String {
    case Normal = "normal"
    case Gaming = "gaming"
    case DualColor = "dualcolor"
}

struct Color {
    var red: UInt8
    var green: UInt8
    var blue: UInt8
}

enum BacklightColor: String {
    case Black = "black"
    case Red = "red"
    case Orange = "orange"
    case Yellow = "yellow"
    case Green = "green"
    case Sky = "sky"
    case Blue = "blue"
    case Purple = "purple"
    case White = "white"
    
    func color() -> Color {
        switch self {
        case .Black: return Color(red: 0, green: 0, blue: 0)
        case .Red: return Color(red: 255, green: 0, blue: 0)
        case .Orange: return Color(red: 255, green: 127, blue: 0)
        case .Yellow: return Color(red: 255, green: 225, blue: 0)
        case .Green: return Color(red: 0, green: 255, blue: 0)
        case .Sky: return Color(red: 0, green: 255, blue: 255)
        case .Blue: return Color(red: 0, green: 0, blue: 255)
        case .Purple: return Color(red: 255, green: 0, blue: 255)
        case .White: return Color(red: 255, green: 255, blue: 255)
        }
    }
}

protocol BacklightModeConfiguration {
    var featureReports: [[UInt8]] { get }
}

class NormalModeConfiguration: BacklightModeConfiguration {
    var leftZoneColor: BacklightColor = .Green
    var centralZoneColor: BacklightColor = .Green
    var rightZoneColor: BacklightColor = .Green
    
    var featureReports: [[UInt8]] {
        var reports: [[UInt8]] = []
        for index: UInt8 in 0...3 {
            let keyboardZoneMapping: [UInt8: BacklightColor] = [1: leftZoneColor, 2: centralZoneColor, 3: rightZoneColor]
            let report: [UInt8]
            
            if index == 0 {
                report = [0x01, 0x02, 0x41, 0x01, 0x00, 0x00, 0x00, 0x00]
            } else {
                let color = keyboardZoneMapping[index]!.color()
                report = [0x01, 0x02, 0x40, index, color.red, color.green, color.blue, 0x00]
            }
            
            reports.append(report)
        }
        return reports
    }
}

class GamingModeConfiguration: BacklightModeConfiguration {
    var zoneColor: BacklightColor = .Green
    
    var featureReports: [[UInt8]] {
        let color = zoneColor.color()
        let reports: [[UInt8]] = [[0x01, 0x02, 0x41, 0x02, 0x00, 0x00, 0x00, 0x00],
                                  [0x01, 0x02, 0x40, 0x01, color.red, color.green, color.blue, 0x00]]
        return reports
    }
}

class DualColorModeConfiguration: BacklightModeConfiguration {
    var firstColor: BacklightColor = .Green
    var secondColor: BacklightColor = .Green
    
    var featureReports: [[UInt8]] {
        let color1 = firstColor.color()
        let color2 = secondColor.color()
        var reports: [[UInt8]] = []
        for index: UInt8 in 0..<3 {
            reports.append([0x01, 0x02, 0x44, index * 3 + 1, color1.red, color1.green, color1.blue, 0x00])
            reports.append([0x01, 0x02, 0x44, index * 3 + 2, color2.red, color2.green, color2.blue, 0x00])
            reports.append([0x01, 0x02, 0x44, index * 3 + 3, 0x03, 0x03, 0x03, 0x00])
            reports.append([0x01, 0x02, 0x41, 0x06, 0x00, 0x00, 0x00, 0x00])
        }
        return reports
    }
}
