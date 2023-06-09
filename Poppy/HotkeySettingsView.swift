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
            
            Text("Toggle Window Pinning")
            KeyboardShortcuts.Recorder("", name: .togglePinningShortcut)

            Divider()

            Text("Quick Alpha")
            KeyboardShortcuts.Recorder("", name: .toggleAlphaShortcut)
        }
    }
}

struct HotkeySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HotkeySettingsView()
    }
}
