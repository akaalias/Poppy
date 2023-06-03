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
                WebViewWithUrlBar()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("URLBarColor"))
            } else {
                TuckedView()
                    .frame(width: 100, height: 100)
                    .background(Color("URLBarColor"))
            }
        }
        .onChange(of: state.isPinned) { newValue in
            decideWindowLevel()
        }
        .onChange(of: state.isTucked) { newValue in
            changeTuckedState()
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unifiedCompact)
        
    }
    
    func decideWindowLevel() {
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
                window.setFrame(NSRect(x: (NSScreen.main?.frame.width ?? 500) - 50,
                                       y: (NSScreen.main?.frame.height ?? 500) / 2,
                                       width: 100,
                                       height: 100),
                                display: true)

                window.level = NSWindow.Level.floating
                window.standardWindowButton(.zoomButton)?.isHidden = true
                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true

            } else {
                // Reset to default
                window.setFrame(NSRect(x: (NSScreen.main?.frame.width ?? 500) - (NSScreen.main?.frame.width ?? 500) / 2,
                                       y: (NSScreen.main?.frame.height ?? 500),
                                       width: (NSScreen.main?.frame.width ?? 500) / 2,
                                       height: (NSScreen.main?.frame.height ?? 500)),
                                display: true)

                window.standardWindowButton(.zoomButton)?.isHidden = false
                window.standardWindowButton(.closeButton)?.isHidden = false
                window.standardWindowButton(.miniaturizeButton)?.isHidden = false
                window.isMovable = true
                window.isMovableByWindowBackground = true
                window.styleMask.insert(.resizable)
            }
        }
    }
}
