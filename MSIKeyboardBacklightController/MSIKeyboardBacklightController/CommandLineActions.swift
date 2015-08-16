//
//  CommandLineActions.swift
//  MSIKeyboardBacklightController
//
//  Created by Rostyslav Dovhaliuk on 8/2/15.
//  Copyright © 2015 Rostyslav Dovhaliuk. All rights reserved.
//

import Foundation

protocol CommandLineAction {
    func commandLineOptions() -> [Option]
    func run() throws
}

class SetNormalBacklightModeAction: CommandLineAction {
    private let colorLeftOption = EnumOption<BacklightColor>(longFlag: "color1", required: true, helpMessage: "")
    private let colorCenterOption = EnumOption<BacklightColor>(longFlag: "color2", required: true, helpMessage: "")
    private let colorRightOption = EnumOption<BacklightColor>(longFlag: "color3", required: true, helpMessage: "")
    
    func commandLineOptions() -> [Option] {
        let mode = BoolOption(longFlag: BacklightModeType.Normal.rawValue, required: true, helpMessage: "")
        return [mode, colorLeftOption, colorCenterOption, colorRightOption]
    }
    
    func run() throws {
        guard let leftColor = colorLeftOption.value,
              let centralColor = colorCenterOption.value,
              let rightColor = colorRightOption.value
            else { return }
        
        let modeConfiguration = NormalModeConfiguration()
        modeConfiguration.leftZoneColor = leftColor
        modeConfiguration.centralZoneColor = centralColor
        modeConfiguration.rightZoneColor = rightColor
        
        let controller = KeyboardBacklightController()
        try controller.setConfiguration(modeConfiguration)
        PreferencesManager.setModeConfigurationAsDefault(modeConfiguration)
        print("Successfuly changed keyboard backlight configuration.")
    }
}

class SetGamingBacklightModeAction: CommandLineAction {
    private let colorOption = EnumOption<BacklightColor>(longFlag: "color", required: true, helpMessage: "")
    
    func commandLineOptions() -> [Option] {
        let mode = BoolOption(longFlag: BacklightModeType.Gaming.rawValue, required: true, helpMessage: "")
        return [mode, colorOption]
    }
    
    func run() throws {
        guard let color = colorOption.value else { return }
        
        let modeConfiguration = GamingModeConfiguration()
        modeConfiguration.zoneColor = color
        
        let controller = KeyboardBacklightController()
        try controller.setConfiguration(modeConfiguration)
        PreferencesManager.setModeConfigurationAsDefault(modeConfiguration)
        print("Successfuly changed keyboard backlight configuration.")
    }
}

class SetDualColorBacklightModeAction: CommandLineAction {
    private let firstColorOption = EnumOption<BacklightColor>(longFlag: "color1", required: true, helpMessage: "")
    private let secondColorOption = EnumOption<BacklightColor>(longFlag: "color2", required: true, helpMessage: "")
    
    func commandLineOptions() -> [Option] {
        let mode = BoolOption(longFlag: BacklightModeType.DualColor.rawValue, required: true, helpMessage: "")
        return [mode, firstColorOption, secondColorOption]
    }
    
    func run() throws {
        guard let firstColor = firstColorOption.value,
              let secondColor = secondColorOption.value
            else { return }
        
        let modeConfiguration = DualColorModeConfiguration()
        modeConfiguration.firstColor = firstColor
        modeConfiguration.secondColor = secondColor
        
        let controller = KeyboardBacklightController()
        try controller.setConfiguration(modeConfiguration)
        PreferencesManager.setModeConfigurationAsDefault(modeConfiguration)
        print("Successfuly changed keyboard backlight configuration.")
    }
}

class RestoreLastModeAction: CommandLineAction {
    func commandLineOptions() -> [Option] {
        let option = BoolOption(shortFlag: "r", longFlag: "restore", required: true, helpMessage: "")
        return [option]
    }
    
    func run() throws {
        guard let modeConfiguration = PreferencesManager.defaultModeConfiguration() else {
            print("Warning: Nothing to restore, preferences file is empty.")
            return
        }
        let controller = KeyboardBacklightController()
        try controller.setConfiguration(modeConfiguration)
        print("Successfuly restored keyboard backlight configuration.")
    }
}

class PrintHelpInfoAction: CommandLineAction {
    static let usageMessage =
    "Control keyboard's backlight on MSI laptops that support SteelSeries Engine 2.\n" +
    "Usage: msikeyboardbacklightcontroller [options]\n" +
    "--help      % Print this info\n" +
    "--restore   % Apply last configuration\n" +
    "--normal --color1 green --color2 yellow --color3 orange % Set normal mode " +
    "where each keyboard segment is constantly illuminated using specified color.\n" +
    "--gaming --color yellow % Set gaming mode where only left keyboard segment is " +
    "illuminated while others are turned off.\n" +
    "--dualcolor --color1 purple --color2 orange % Set dual color mode where color of keyboard's " +
    "backlight crossfades between two specified colors.\n" +
    "Available colors: black, red, orange, yellow, green, sky, blue, purple, white."
    
    func commandLineOptions() -> [Option] {
        let option = BoolOption(shortFlag: "h", longFlag: "help", required: true, helpMessage: "")
        return [option]
    }
    
    func run() {
        print(PrintHelpInfoAction.usageMessage)
    }
}
