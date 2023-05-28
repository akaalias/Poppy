//
//  SettingsView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 28.05.23.
//

import SwiftUI

struct SettingsTabsView: View {
    @StateObject private var settings = AppState.shared

    var body: some View {
        TabView {
            ResetSettingsView()
                .tabItem {
                    Label("Reset", systemImage: "arrow.clockwise")
                }
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabsView()
    }
}
