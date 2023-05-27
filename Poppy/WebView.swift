//
//  WebView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import SwiftUI
import WebKit

struct WebViewWithUrlBar: View {
    @State private var urlString = ""
    @State private var isHovering = false
    @StateObject private var webViewStore = WebViewStore()
    @State var hovering = false
    @StateObject private var settings = Settings.shared
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter a URL", text: $urlString, onCommit: {
                    if urlString.hasPrefix("https://") {
                        webViewStore.loadUrl(urlString)
                    }
                })
                .padding(.leading, 72)
                .font(.body)
                .textFieldStyle(.plain)
                
                Image(systemName: settings.isPinned ? "pin.fill" : "pin")
                    .foregroundColor(Color("PinColor"))
                    .onTapGesture {
                        settings.isPinned.toggle()
                    }
                    .fixedSize()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                
                Spacer()
            }
            .padding(.top, 6)
            .opacity(hovering ? 1.0 : 0.2)
            .transition(.opacity)
            .animation(.easeOut(duration: 0.3))
            .onHover { hovering in
                toggleVisibilityToggle()
            }
            
            
            WebView(webView: webViewStore.webView)
        }
    }
    
    func toggleVisibilityToggle() {
        hovering.toggle()
    }
}

class WebViewStore: NSObject, ObservableObject {
    let webView = WKWebView()
    let loaded = false
    
    func loadUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

struct WebView: NSViewRepresentable {
    let webView: WKWebView
    @State var loaded = false
    
    func makeNSView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if !self.loaded {
            nsView.setValue(false, forKey: "drawsBackground")
        } else {
            nsView.setValue(true, forKey: "drawsBackground")
        }
        
        self.loaded = true
    }
}
