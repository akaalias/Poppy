//
//  PoppyApp.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import SwiftUI
import Cocoa

@main
struct PoppyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var state = AppState.shared
    
    var body: some Scene {
        Settings {
            SettingsTabsView()
                .frame(width: 500, height: 200)
        }
        
        WindowGroup {
            if !state.isTucked {
                ContentView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            } else {
                TuckedView()
                    .offset(x: -12, y: -14)
                    .onTapGesture {
                        state.isTucked = false
                    }
            }
        }
        .onChange(of: state.isPinned) { newValue in
            bringToFront()
        }
        .onChange(of: state.isTucked) { newValue in
            changeTuckedState()
        }
        .windowStyle(.hiddenTitleBar)
    }
    
    func bringToFront() {
        if let window = NSApplication.shared.windows.first {
            if state.isPinned {
                window.level = .floating
            } else {
                window.level = .normal
            }
        }
    }
    
    func changeTuckedState() {
        if let window = NSApplication.shared.windows.first {
            if state.isTucked {
                window.setFrame(NSRect(x: (NSScreen.main?.frame.width ?? 500) - 25,
                                       y: (NSScreen.main?.frame.height ?? 500) / 2,
                                       width: 50,
                                       height: 50),
                                display: true)

                window.level = NSWindow.Level.floating

                window.backgroundColor = NSColor(Color("URLBarColor"))

                window.standardWindowButton(.zoomButton)?.isHidden = true
                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.isMovableByWindowBackground = false
                window.isMovable = false
                window.styleMask.remove(.resizable)

            } else {
                // Reset to default
                window.setFrame(NSRect(x: (NSScreen.main?.frame.width ?? 500) - 400,
                                       y: (NSScreen.main?.frame.height ?? 500),
                                       width: 400,
                                       height: (NSScreen.main?.frame.height ?? 500)),
                                display: true)
                window.isMovable = true
                window.isMovableByWindowBackground = true
                window.styleMask.insert(.resizable)
            }
        }
    }
}
