//
//  PoppyApp.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import SwiftUI

@main
struct PoppyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var settings = Settings.shared
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .active:
                        bringToFront()
                    case .inactive:
                        bringToFront()
                    case .background:
                        bringToFront()
                    @unknown default:
                        fatalError("Unhandled scene phase")
                    }
                }
                .onChange(of: settings.isPinned) { newValue in
                    bringToFront()
                }
        }
        .windowStyle(.hiddenTitleBar)
    }
    
    func bringToFront() {
        if let window = NSApplication.shared.windows.first {
            if settings.isPinned {
                window.level = .floating
            } else {
                window.level = .normal
            }
        }
    }
}
