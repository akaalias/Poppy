//
//  Settings.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import Foundation
import SwiftUI

enum SettingsKeys: String, CaseIterable{
    case isPinned = "isPinned"
    case lastURL = "lastURL"
    case isTucked = "isTucked"
}

class AppState: ObservableObject {
    static let shared = AppState()
    static let DEFAULT_IS_PINNED_STATE = true
    static let DEFAULT_LAST_URL_STATE = ""
    static let DEFAULT_IS_TUCKED_STATE = false

    @Published var urlInputString = AppState.DEFAULT_LAST_URL_STATE
    
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
    
    @AppStorage(SettingsKeys.isTucked.rawValue) var isTucked = AppState.DEFAULT_IS_TUCKED_STATE {
        didSet {
            objectWillChange.send()
        }
    }
    
    func reset() {
        self.isPinned = AppState.DEFAULT_IS_PINNED_STATE
        self.lastURL = AppState.DEFAULT_LAST_URL_STATE
        self.urlInputString = AppState.DEFAULT_LAST_URL_STATE
        self.isTucked = AppState.DEFAULT_IS_TUCKED_STATE
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
