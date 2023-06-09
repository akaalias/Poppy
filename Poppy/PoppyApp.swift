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
                        Label("Updates", systemImage: "arrow.clockwise")
                    }
                
            }
            .padding()
            .frame(width: 500, height: 200)
        }
        
        WindowGroup {
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
}
