//
//  URLBarNavigationItems.swift
//  Poppy
//
//  Created by Alexis Rondeau on 29.05.23.
//

import SwiftUI

struct URLBarNavigationItems: View {
    @StateObject private var state = AppState.shared

    var body: some View {
        HStack {            
            Image(systemName: "line.3.horizontal")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(Color("PinColor"))
            
            Spacer()

            Image(systemName: state.isPinned ? "pin.fill" : "pin")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(Color("PinColor"))
                .onTapGesture {
                    state.isPinned.toggle()
                }

            Spacer()
            
            Image(systemName: "chevron.forward")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(Color("PinColor"))
                .onTapGesture {
                    state.isTucked = true
                }
            
            Spacer()
        }
        .frame(maxWidth: 70)
    }
}

struct URLBarNavigationItems_Previews: PreviewProvider {
    static var previews: some View {
        URLBarNavigationItems()
    }
}
