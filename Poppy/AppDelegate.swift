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
            if state.isPinned {
                window.level = NSWindow.Level.floating
            }
            state.windowFrame = window.frame
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {}
    func applicationDidResignActive(_ notification: Notification) {}
}
