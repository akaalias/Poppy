//
//  DefaultURLSettingsView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 28.05.23.
//

import SwiftUI

struct DefaultURLSettingsView: View {
    @StateObject private var settings = AppState.shared

    var body: some View {
        Form {
            TextField("Default URL", text: settings.$lastURL)
        }
        .padding()
    }
}

struct DefaultURLSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultURLSettingsView()
    }
}
