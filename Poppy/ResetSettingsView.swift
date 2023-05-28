//
//  ResetSettingsView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 28.05.23.
//

import SwiftUI

struct ResetSettingsView: View {
    @State var message = ""

    var body: some View {
        VStack {
            Button {
                UserDefaults.standard.resetUser()
                message = "Settings have been reset!"
            } label: {
                Text("Reset")
            }
            
            Text(message)
        }
    }
}

struct ResetSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ResetSettingsView()
    }
}
