//
//  Settings.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

enum SettingsKeys: String, CaseIterable{
    case isPinned = "isPinned"
    case lastURL = "lastURL"
}

class AppState: ObservableObject {
    static let shared = AppState()
    static let DEFAULT_IS_PINNED_STATE = true
    static let DEFAULT_LAST_URL_STATE = "https://"
    
    @Published var urlInputString = AppState.DEFAULT_LAST_URL_STATE
    
    init() {
        KeyboardShortcuts.onKeyUp(for: .togglePinning) { [self] in
            isPinned.toggle()
        }
    }
    
    @AppStorage(SettingsKeys.isPinned.rawValue) var isPinned = AppState.DEFAULT_IS_PINNED_STATE {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(SettingsKeys.lastURL.rawValue) var lastURL = AppState.DEFAULT_LAST_URL_STATE {
        didSet {
            objectWillChange.send()
        }
    }
    
    func reset() {
        self.isPinned = AppState.DEFAULT_IS_PINNED_STATE
        self.lastURL = AppState.DEFAULT_LAST_URL_STATE
        self.urlInputString = AppState.DEFAULT_LAST_URL_STATE
    }
}

extension UserDefaults {
    func resetUser(){
        SettingsKeys.allCases.forEach{
            removeObject(forKey: $0.rawValue)
        }
        
        AppState.shared.reset()
    }
}
