//
//  AboutSettingsView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 09.06.23.
//

import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            
            Text("Release Version: \(Bundle.main.releaseVersionNumber!)")
            Text("Build Version: \(Bundle.main.buildVersionNumber!)")
        }
    }
}

struct AboutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingsView()
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

