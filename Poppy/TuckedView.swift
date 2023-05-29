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
            Image(systemName: "chevron.left")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(Color("PinColor"))
    }
}

struct TuckedView_Previews: PreviewProvider {
    static var previews: some View {
        TuckedView()
    }
}
