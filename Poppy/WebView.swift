//
//  WebView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import SwiftUI
import WebKit

struct WebViewWithUrlBar: View {
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    
    @State private var urlString = ""
    @State private var isHovering = false
    @StateObject private var webViewStore = WebViewStore()
    @State var hovering = false
    @StateObject private var settings = Settings.shared
    @State private var size: CGSize = .zero
    @State private var distanceOfMouseFromTopOfWindowFrame: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            WebView(webView: webViewStore.webView)
                .ignoresSafeArea()
                .background(.clear)
            
            .safeAreaInset(edge: .top, content: {
                HStack(spacing: 0) {
                    TextField("Enter a URL", text: $urlString, onCommit: {
                        if !urlString.isEmpty {
                            if  !urlString.hasPrefix("https://") {
                                self.urlString = "https://" + self.urlString
                            }
                            webViewStore.loadUrl(urlString)
                        }
                    })
                    .padding(.leading, 72)
                    .font(.body)
                    .textFieldStyle(.plain)
                    .foregroundColor(Color("URLBarText"))
                    
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
                .padding(.top, 8)
                .padding(.bottom, 8)
                .frame(height: hovering ? 28 : 0)
                .offset(y: hovering ? 0 : -10)
                .background(Color("URLBarColor"))
                .animation(.easeOut(duration: 0.3))
                .onChange(of: self.distanceOfMouseFromTopOfWindowFrame) { newValue in
                    if newValue > 30 {
                        hovering = false
                    } else {
                        hovering = true
                    }
                }
            })
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                    self.distanceOfMouseFromTopOfWindowFrame = size.height - event.locationInWindow.y
                    return event
                }
                size = geometry.size
                
                self.hovering = true
            }.onChange(of: geometry.size) { newSize in
                size = newSize
            }
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
    
    func makeNSView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.setValue(false, forKey: "drawsBackground")
    }
}
