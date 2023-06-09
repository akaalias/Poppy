//
//  Constants.swift
//  Poppy
//
//  Created by Alexis Rondeau on 09.06.23.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let togglePinningShortcut = Self("togglePinningShortcut", default: Shortcut(.p, modifiers: [.command, .control, .option]))
    static let toggleAlphaShortcut = Self("toggleAlphaShortcut", default: Shortcut(.o, modifiers: [.command, .control, .option]))
}
