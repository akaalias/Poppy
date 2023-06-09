//
//  WebView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import SwiftUI
import WebKit

struct WebViewWithUrlBar: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var webViewStore = WebViewStore()
    @StateObject private var state = AppState.shared
    @State var hovering = false
    
    var body: some View {
        WebView(webView: webViewStore.webView)
            .onAppear {
                state.urlInputString = state.lastURL
                tryToLoadURLFromURLString()
            }
            .onChange(of: state.lastURL) { newValue in
                tryToLoadURLFromURLString()
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .navigation, content: {
                    TextField("https://", text: $state.urlInputString, onCommit: {
                        self.tryToLoadURLFromURLString()
                    })
                    .font(.body)
                    .textFieldStyle(.squareBorder)
                    .foregroundColor(Color("URLBarText"))
                    .frame(width: 200)
                })
                
                ToolbarItemGroup(placement: .automatic, content: {
                    Image(systemName: state.isPinned ? "circlebadge.fill" : "circlebadge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color("PinColor"))
                        .onTapGesture {
                            state.isPinned.toggle()
                        }
                    
                    Spacer()
                })
            }
    }
    
    func tryToLoadURLFromURLString() {
        if !state.urlInputString.isEmpty &&  !(state.urlInputString == "https://"){
            if  !state.urlInputString.hasPrefix("https://") {
                state.urlInputString = "https://" + state.urlInputString
            }
            
            if state.urlInputString != state.lastURL {
                state.lastURL = state.urlInputString
            }
            
            webViewStore.loadUrl(state.lastURL)
            
        } else {
            webViewStore.webView.loadHTMLString(DEFAULT_HTML_STRING, baseURL: URL(string: ""))
        }
    }
}

