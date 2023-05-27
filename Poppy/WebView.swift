//
//  WebView.swift
//  Poppy
//
//  Created by Alexis Rondeau on 27.05.23.
//

import SwiftUI
import WebKit

struct WebViewWithUrlBar: View {
    @StateObject private var webViewStore = WebViewStore()
    @StateObject private var settings = Settings.shared
    @State private var urlString = ""
    @State private var isHovering = false
    @State var hovering = false
    @State private var size: CGSize = .zero
    @State private var distanceOfMouseFromTopOfWindowFrame: CGFloat = 0.0
    
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    
    var body: some View {
        GeometryReader { geometry in
            WebView(webView: webViewStore.webView)
                .ignoresSafeArea()
                .background(.clear)
                .safeAreaInset(edge: .top, content: {
                    HStack {
                        Spacer()
                        
                        Circle()
                            .fill(.gray.opacity(0.5))
                            .frame(width: 12, height: 12)

                        Circle()
                            .fill(.gray.opacity(0.5))
                            .frame(width: 12, height: 12)

                        Circle()
                            .fill(.gray.opacity(0.5))
                            .frame(width: 12, height: 12)

                        TextField("Enter a URL", text: $urlString, onCommit: {
                            if !urlString.isEmpty {
                                if  !urlString.hasPrefix("https://") {
                                    self.urlString = "https://" + self.urlString
                                }
                                
                                settings.lastURL = self.urlString
                                webViewStore.loadUrl(urlString)
                            }
                        })
                        .font(.body)
                        .textFieldStyle(.plain)
                        .foregroundColor(Color("URLBarText"))
                        
                        Spacer()
                        
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(Color("PinColor"))
                            .fixedSize()
                            .scaledToFit()
                            .frame(width: 12, height: 12)

                        Spacer()

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
                    .animation(.easeOut(duration: 0.2))
                    .onChange(of: self.distanceOfMouseFromTopOfWindowFrame) { newValue in
                        if newValue > 30 {
                            hovering = false
                            hideWindowControls()
                        } else {
                            hovering = true
                            showWindowControls()
                        }
                    }
                })
                .onAppear {
                    NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                        self.distanceOfMouseFromTopOfWindowFrame = size.height - event.locationInWindow.y
                        return event
                    }
                    size = geometry.size
                    hideWindowControls()
                    self.urlString = settings.lastURL
                }.onChange(of: geometry.size) { newSize in
                    size = newSize
                }
        }
    }
    func hideWindowControls() {
        NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
        NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
        NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
    }
    func showWindowControls() {
        NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = false
        NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = false
        NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = false
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
