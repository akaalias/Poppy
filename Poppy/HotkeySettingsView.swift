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
        VStack(alignment: .leading) {
            
            Text("Toggle Window Pinning")
                .font(.title)
            
            Text("When you really don't need Poppy, use this hotkey to move Poppy to the back.")
                .multilineTextAlignment(.leading)
                .font(.body)
                .opacity(0.7)
            
            KeyboardShortcuts.Recorder("", name: .togglePinningShortcut)

            Divider()

            Text("Briefly Hide Poppy")
                .font(.title)
            
            Text("If you want to check what's behind Poppy's window but want to keep it on-top, try this hotkey!")
                .multilineTextAlignment(.leading)
                .font(.body)
                .opacity(0.7)
            
            KeyboardShortcuts.Recorder("", name: .toggleAlphaShortcut)
        }
    }
}

struct HotkeySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HotkeySettingsView()
    }
}
