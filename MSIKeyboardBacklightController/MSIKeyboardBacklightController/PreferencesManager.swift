//
//  PreferencesManager.swift
//  MSIKeyboardBacklightController
//
//  Created by Rostyslav Dovhaliuk on 8/3/15.
//  Copyright © 2015 Rostyslav Dovhaliuk. All rights reserved.
//

import Foundation

struct SerializationConstants {
    static let BacklightModeKey = "BacklightModeKey"
    static let NormalModeLeftZoneColorKey = "NormalModeLeftZoneColorKey"
    static let NormalModeCentralZoneColor = "NormalModeCentralZoneColor"
    static let NormalModeRightZoneColor = "NormalModeRightZoneColor"
}

class PreferencesManager {
    class func setModeConfigurationAsDefault(configuration: BacklightModeConfiguration) {
        switch configuration {
        case let normalMode as NormalModeConfiguration:
            CFPreferencesSetAppValue(SerializationConstants.BacklightModeKey, BacklightModeType.Normal.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.NormalModeLeftZoneColorKey, normalMode.leftZoneColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.NormalModeCentralZoneColor, normalMode.centralZoneColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.NormalModeRightZoneColor, normalMode.rightZoneColor.rawValue, kCFPreferencesCurrentApplication)
        default:
            break
        }
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
    }
    
    class func defaultModeConfiguration() -> BacklightModeConfiguration? {
        if let configurationName = CFPreferencesCopyAppValue(SerializationConstants.BacklightModeKey, kCFPreferencesCurrentApplication) as? String,
           let configurationType = BacklightModeType(rawValue: configurationName) {
            switch configurationType {
            case .Normal:
                let configuration = NormalModeConfiguration()
                
                if let leftColorName = CFPreferencesCopyAppValue(SerializationConstants.NormalModeLeftZoneColorKey, kCFPreferencesCurrentApplication) as? String,
                    let leftColor = BacklightColor(rawValue: leftColorName) {
                    configuration.leftZoneColor = leftColor
                }

                if let centralColorName = CFPreferencesCopyAppValue(SerializationConstants.NormalModeCentralZoneColor, kCFPreferencesCurrentApplication) as? String,
                    let centralColor = BacklightColor(rawValue: centralColorName) {
                        configuration.centralZoneColor = centralColor
                }

                if let rightColorName = CFPreferencesCopyAppValue(SerializationConstants.NormalModeRightZoneColor, kCFPreferencesCurrentApplication) as? String,
                    let rightColor = BacklightColor(rawValue: rightColorName) {
                        configuration.rightZoneColor = rightColor
                }
                
                return configuration
            }
        }
        return nil
    }
    
}
