//
//  TuckedView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 29.05.23.
//

import SwiftUI

struct TuckedView: View {
    @StateObject private var state = AppState.shared

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Button {
                    state.isTucked = false
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("PinColor"))
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("")
    }
}

struct TuckedView_Previews: PreviewProvider {
    static var previews: some View {
        TuckedView()
    }
}
