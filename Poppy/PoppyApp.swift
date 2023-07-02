//
//  PoppyApp.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import SwiftUI
import Cocoa
import Sparkle

@main
struct PoppyApp: App {
    private let updaterController: SPUStandardUpdaterController
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var state = AppState.shared
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        Settings {
            TabView {
                HotkeySettingsView()
                    .tabItem {
                        Label("Hotkey", systemImage: "keyboard")
                    }
                
                UpdaterSettingsView(updater: updaterController.updater)
                    .tabItem {
                        Label("Updates", systemImage: "gift")
                    }                

                ResetSettingsView()
                    .tabItem {
                        Label("Reset", systemImage: "arrow.clockwise")
                    }

            }
            .padding()
            .frame(width: 600, height: 250)
        }
        
        Window("Poppy", id: "poppy") {
            WebViewWithUrlBar()
                .background(Color("URLBarColor"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: updaterController.updater)
            }
        }
        .onChange(of: state.isPinned) { newValue in
            decideWindowLevel()
        }
        .onChange(of: state.shouldBeVisible) { newValue in
            setWindowAlphaValue(shouldBeVisible: newValue)
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
    
    func setWindowAlphaValue(shouldBeVisible: Bool) {
        if let window = NSApplication.shared.windows.first {
            if shouldBeVisible {
                //                NSAnimationContext.runAnimationGroup({ (context) -> Void in
                //                    context.duration = 0.5
                //                    window.animator().alphaValue = 1.0
                //                }, completionHandler: nil)
                
                window.animator().alphaValue = 1.0
                
                let width = state.windowFrame!.size.width
                let height = state.windowFrame!.size.height
                let oldX = state.windowFrame!.origin.x
                let oldY = state.windowFrame!.origin.y
                let newWindowFrame = NSMakeRect(oldX,
                                                oldY,
                                                width,
                                                height)
                
                window.animator().setFrame(newWindowFrame, display: true, animate: true)
                
            } else {
                // Save last position
                window.animator().alphaValue = 0.05
                
                state.windowFrame = window.frame
                
                let width = state.windowFrame!.size.width
                let height = state.windowFrame!.size.height
                
                var newx = NSScreen.main!.frame.width + width
                
                // But if the window is currently on the left side...
                if state.windowFrame!.origin.x + (width / 2.0) < (NSScreen.main!.frame.width / 2.0) {
                    newx = 0 - width
                }
                
                let newWindowFrame = NSMakeRect(newx,
                                                state.windowFrame!.origin.y,
                                                width,
                                                height)
                
                window.animator().setFrame(newWindowFrame, display: true, animate: true)
            }
        }
    }
}
