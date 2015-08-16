//
//  main.swift
//  MSIKeyboardBacklightController
//
//  Created by Rostyslav Dovhaliuk on 7/26/15.
//  Copyright © 2015 Rostyslav Dovhaliuk. All rights reserved.
//

import Foundation

let actions: [CommandLineAction] = [PrintHelpInfoAction(), RestoreLastModeAction(), SetNormalBacklightModeAction(), SetGamingBacklightModeAction()]
let cli = CommandLine()

for action: CommandLineAction in actions {
    cli.setOptions(action.commandLineOptions())
    do {
        try cli.parse()
        try action.run()
        exit(EXIT_SUCCESS)
    } catch USBError.USBOperation(let text) {
        print("Error: \(text)")
        exit(EXIT_FAILURE)
    } catch {
        continue
    }
}

print(PrintHelpInfoAction.usageMessage)