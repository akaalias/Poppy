//
//  Settings.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    static let shared = Settings()

    @AppStorage("isPinned") var isPinned = false {
        didSet {
            objectWillChange.send()
        }
    }
}
