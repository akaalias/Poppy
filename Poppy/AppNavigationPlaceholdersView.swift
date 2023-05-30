//
//  AppNavigationPlaceholdersView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 28.05.23.
//

import SwiftUI

struct AppNavigationPlaceholdersView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(.gray.opacity(0.5))
                .frame(width: 12, height: 12)

            Circle()
                .fill(.gray.opacity(0.5))
                .frame(width: 12, height: 12)

            Circle()
                .fill(.gray.opacity(0.5))
                .frame(width: 12, height: 12)
        }
        .offset(y: -2)
    }
}

struct AppNavigationPlaceholdersView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavigationPlaceholdersView()
    }
}
