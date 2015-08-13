//
//  main.swift
//  MSIKeyboardBacklightController
//
//  Created by Rostyslav Dovhaliuk on 7/26/15.
//  Copyright © 2015 Rostyslav Dovhaliuk. All rights reserved.
//

import Foundation

let actions: [CommandLineAction] = [PrintHelpInfoAction(), RestoreLastModeAction(), SetNormalBacklightModeAction()]
let cli = CommandLine()

for action: CommandLineAction in actions {
    cli.setOptions(action.commandLineOptions())
    do {
        try cli.parse()
        action.run()
        exit(EXIT_SUCCESS)
    } catch {
        continue
    }
}

print(PrintHelpInfoAction.usageMessage)