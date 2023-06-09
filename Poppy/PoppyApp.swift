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
                UpdaterSettingsView(updater: updaterController.updater)
                    .tabItem {
                        Label("Updates", systemImage: "arrow.clockwise")
                    }
                
            }
            .padding()
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
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: updaterController.updater)
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


// This view model class publishes when new updates can be checked by the user
final class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdates = false
    
    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }
}

// This is the view for the Check for Updates menu item
// Note this intermediate view is necessary for the disabled state on the menu item to work properly before Monterey.
// See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more info
struct CheckForUpdatesView: View {
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater
    
    init(updater: SPUUpdater) {
        self.updater = updater
        
        // Create our view model for our CheckForUpdatesView
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
    }
    
    var body: some View {
        Button("Check for Updates…", action: updater.checkForUpdates)
            .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
    }
}

struct UpdaterSettingsView: View {
    private let updater: SPUUpdater
    
    @State private var automaticallyChecksForUpdates: Bool
    @State private var automaticallyDownloadsUpdates: Bool
    
    init(updater: SPUUpdater) {
        self.updater = updater
        self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
        self.automaticallyDownloadsUpdates = updater.automaticallyDownloadsUpdates
    }
    
    var body: some View {
        VStack {
            AboutSettingsView()
            
            Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
                .onChange(of: automaticallyChecksForUpdates) { newValue in
                    updater.automaticallyChecksForUpdates = newValue
                }
            
            Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
                .disabled(!automaticallyChecksForUpdates)
                .onChange(of: automaticallyDownloadsUpdates) { newValue in
                    updater.automaticallyDownloadsUpdates = newValue
                }
        }.padding()
    }
}
