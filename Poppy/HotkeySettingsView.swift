//
//  HotkeySettingsView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 09.06.23.
//

import SwiftUI
import KeyboardShortcuts

struct HotkeySettingsView: View {
    var body: some View {
        VStack {
            KeyboardShortcuts.Recorder("", name: .togglePinning)
        }
    }
}

struct HotkeySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HotkeySettingsView()
    }
}
