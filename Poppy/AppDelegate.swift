//
//  AppDelegate.swift
//  Poppy
//
//  Created by Alexis Rondeau on 29.05.23.
//

import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    let state = AppState.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            // Starting out with the examples from https://github.com/lukakerr/NSWindowStyles/
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            window.hasShadow = false

            if state.isTucked {
                state.isTucked = false
            }
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            if state.isTucked {
                window.backgroundColor = NSColor(Color("URLBarColor"))
            }
        }
    }

    func applicationDidResignActive(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.backgroundColor = NSColor(Color("URLBarColor").opacity(0.5))
        }
    }
}
