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
    func run()
}

class SetNormalBacklightModeAction: CommandLineAction {
    private let colorLeftOption = EnumOption<BacklightColor>(longFlag: "color1", required: true, helpMessage: "")
    private let colorCenterOption = EnumOption<BacklightColor>(longFlag: "color2", required: true, helpMessage: "")
    private let colorRightOption = EnumOption<BacklightColor>(longFlag: "color3", required: true, helpMessage: "")
    
    func commandLineOptions() -> [Option] {
        let mode = EnumOption<BacklightModeType>(shortFlag: "m", longFlag: "mode", required: true, helpMessage: "")
        return [mode, colorLeftOption, colorCenterOption, colorRightOption]
    }
    
    func run() {
        let modeConfiguration = NormalModeConfiguration()
        guard let leftColor = colorLeftOption.value,
              let centralColor = colorCenterOption.value,
              let rightColor = colorRightOption.value
            else { return }
        
        modeConfiguration.leftZoneColor = leftColor
        modeConfiguration.centralZoneColor = centralColor
        modeConfiguration.rightZoneColor = rightColor
        
        let controller = KeyboardBacklightController()
        do {
            try controller.setConfiguration(modeConfiguration)
            PreferencesManager.setModeConfigurationAsDefault(modeConfiguration)
        } catch USBError.USBOperation(let text) {
            print("Error: \(text)")
            return
        } catch {
            return
        }
        print("Successfuly changed keyboard backlight configuration.")
    }
}

class RestoreLastModeAction: CommandLineAction {
    func commandLineOptions() -> [Option] {
        let option = BoolOption(shortFlag: "r", longFlag: "restore", required: true, helpMessage: "")
        return [option]
    }
    
    func run() {
        guard let modeConfiguration = PreferencesManager.defaultModeConfiguration() else {
            print("Warning: Nothing to restore, preferences file is empty.")
            return
        }
        let controller = KeyboardBacklightController()
        do {
            try controller.setConfiguration(modeConfiguration)
        } catch USBError.USBOperation(let text) {
            print("Error: \(text)")
            return
        } catch {
            return
        }
        print("Successfuly restored keyboard backlight configuration.")
    }
}

class PrintHelpInfoAction: CommandLineAction {
    static let usageMessage =
    "Control keyboard's backlight of MSI laptops that support SteelSeries Engine 2.\n" +
    "Usage: msikeyboardbacklightcontroller [options]\n" +
    "--help      % Print this info\n" +
    "--restore   % Apply last configuration\n" +
    "--mode normal --color1 green --color2 yellow --color3 orange % Set normal mode " +
    "where each keyboard's segment is constantly illuminated using specified color.\n" +
    "Available colors: black, red, orange, yellow, green, sky, blue, purple, white."
    
    func commandLineOptions() -> [Option] {
        let option = BoolOption(shortFlag: "h", longFlag: "help", required: true, helpMessage: "")
        return [option]
    }
    
    func run() {
        print(PrintHelpInfoAction.usageMessage)
    }
}
