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
    static let NormalModeCentralZoneColorKey = "NormalModeCentralZoneColorKey"
    static let NormalModeRightZoneColorKey = "NormalModeRightZoneColorKey"
    
    static let GamingModeZoneColorKey = "GamingModeZoneColorKey"
    
    static let DualColorFirstColorKey = "DualColorFirstColorKey"
    static let DualColorSecondColorKey = "DualColorSecondColorKey"
    
    static let WaveFirstColorKey = "WaveFirstColorKey"
    static let WaveSecondColorKey = "WaveSecondColorKey"
    static let WaveThirdColorKey = "WaveThirdColorKey"
    
    static let BreathingFirstColorKey = "BreathingFirstColorKey"
    static let BreathingSecondColorKey = "BreathingSecondColorKey"
    static let BreathingThirdColorKey = "BreathingThirdColorKey"
}

class PreferencesManager {
    class func setModeConfigurationAsDefault(configuration: BacklightModeConfiguration) {
        switch configuration {
        case let normalMode as NormalModeConfiguration:
            CFPreferencesSetAppValue(SerializationConstants.BacklightModeKey, BacklightModeType.Normal.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.NormalModeLeftZoneColorKey, normalMode.leftZoneColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.NormalModeCentralZoneColorKey, normalMode.centralZoneColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.NormalModeRightZoneColorKey, normalMode.rightZoneColor.rawValue, kCFPreferencesCurrentApplication)
        case let gamingMode as GamingModeConfiguration:
            CFPreferencesSetAppValue(SerializationConstants.BacklightModeKey, BacklightModeType.Gaming.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.GamingModeZoneColorKey, gamingMode.zoneColor.rawValue, kCFPreferencesCurrentApplication)
        case let dualColorMode as DualColorModeConfiguration:
            CFPreferencesSetAppValue(SerializationConstants.BacklightModeKey, BacklightModeType.DualColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.DualColorFirstColorKey, dualColorMode.firstColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.DualColorSecondColorKey, dualColorMode.secondColor.rawValue, kCFPreferencesCurrentApplication)
        case let waveMode as WaveModeConfiguration:
            CFPreferencesSetAppValue(SerializationConstants.BacklightModeKey, BacklightModeType.Wave.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.WaveFirstColorKey, waveMode.firstColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.WaveSecondColorKey, waveMode.secondColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.WaveThirdColorKey, waveMode.thirdColor.rawValue, kCFPreferencesCurrentApplication)
        case let breathingMode as BreathingModeConfiguration:
            CFPreferencesSetAppValue(SerializationConstants.BacklightModeKey, BacklightModeType.Breathing.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.BreathingFirstColorKey, breathingMode.firstColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.BreathingSecondColorKey, breathingMode.secondColor.rawValue, kCFPreferencesCurrentApplication)
            CFPreferencesSetAppValue(SerializationConstants.BreathingThirdColorKey, breathingMode.thirdColor.rawValue, kCFPreferencesCurrentApplication)
        default:
            fatalError("Unknown configuration was passed for serialization")
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
                if let centralColorName = CFPreferencesCopyAppValue(SerializationConstants.NormalModeCentralZoneColorKey, kCFPreferencesCurrentApplication) as? String,
                    let centralColor = BacklightColor(rawValue: centralColorName) {
                        configuration.centralZoneColor = centralColor
                }
                if let rightColorName = CFPreferencesCopyAppValue(SerializationConstants.NormalModeRightZoneColorKey, kCFPreferencesCurrentApplication) as? String,
                    let rightColor = BacklightColor(rawValue: rightColorName) {
                        configuration.rightZoneColor = rightColor
                }
                return configuration
                
            case .Gaming:
                let configuration = GamingModeConfiguration()
                if let colorName = CFPreferencesCopyAppValue(SerializationConstants.GamingModeZoneColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: colorName) {
                        configuration.zoneColor = color
                }
                return configuration
                
            case .DualColor:
                let configuration = DualColorModeConfiguration()
                if let firstColorName = CFPreferencesCopyAppValue(SerializationConstants.DualColorFirstColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: firstColorName) {
                        configuration.firstColor = color
                }
                if let secondColorName = CFPreferencesCopyAppValue(SerializationConstants.DualColorSecondColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: secondColorName) {
                        configuration.secondColor = color
                }
                return configuration
                
            case .Wave:
                let configuration = WaveModeConfiguration()
                if let firstColorName = CFPreferencesCopyAppValue(SerializationConstants.WaveFirstColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: firstColorName) {
                        configuration.firstColor = color
                }
                if let secondColorName = CFPreferencesCopyAppValue(SerializationConstants.WaveSecondColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: secondColorName) {
                        configuration.secondColor = color
                }
                if let thirdColorName = CFPreferencesCopyAppValue(SerializationConstants.WaveThirdColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: thirdColorName) {
                        configuration.thirdColor = color
                }
                return configuration
             
            case .Breathing:
                let configuration = BreathingModeConfiguration()
                if let firstColorName = CFPreferencesCopyAppValue(SerializationConstants.BreathingFirstColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: firstColorName) {
                        configuration.firstColor = color
                }
                if let secondColorName = CFPreferencesCopyAppValue(SerializationConstants.BreathingSecondColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: secondColorName) {
                        configuration.secondColor = color
                }
                if let thirdColorName = CFPreferencesCopyAppValue(SerializationConstants.BreathingThirdColorKey, kCFPreferencesCurrentApplication) as? String,
                    let color = BacklightColor(rawValue: thirdColorName) {
                        configuration.thirdColor = color
                }
                return configuration
            }
        }
        return nil
    }
    
}
