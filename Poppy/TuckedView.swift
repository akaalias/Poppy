//
//  TuckedView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 29.05.23.
//

import SwiftUI

struct TuckedView: View {
    @StateObject private var state = AppState.shared
    @State var hovering = false

    var body: some View {
        Image(systemName: "chevron.left")
        .foregroundColor(Color("PinColor"))
        .background(Circle()
            .fill(Color("URLBarColor"))
            .frame(width: 100, height: 100)
        )
        .opacity(self.hovering ? 1 : 0.5)
        .transition(.opacity)
        .animation(.easeOut)
        .onHover(perform: { hover in
            self.hovering = hover
        })
    }
}

struct TuckedView_Previews: PreviewProvider {
    static var previews: some View {
        TuckedView()
    }
}
