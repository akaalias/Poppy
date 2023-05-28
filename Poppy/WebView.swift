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
    
    @State var hovering = true
    @State private var size: CGSize = .zero
    @State private var distanceOfMouseFromTopOfWindowFrame: CGFloat = 0.0
    
    @State var mouseMonitor: Any?
    
    var body: some View {
        GeometryReader { geometry in
            WebView(webView: webViewStore.webView)
                .ignoresSafeArea()
                .safeAreaInset(edge: .top, content: {
                    HStack {
                        Spacer()
                        
                        AppNavigationPlaceholdersView()
                        
                        TextField("Enter your URL", text: $state.urlInputString, onCommit: {
                            self.tryToLoadURLFromURLString()
                        })
                        
                        
                        .font(.body)
                        .textFieldStyle(.plain)
                        .foregroundColor(Color("URLBarText"))
                        
                        if webViewStore.loading {
                            ProgressView()
                                .controlSize(.small)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(Color("PinColor"))
                            .fixedSize()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                        
                        Image(systemName: state.isPinned ? "pin.fill" : "pin")
                            .foregroundColor(Color("PinColor"))
                            .onTapGesture {
                                state.isPinned.toggle()
                            }
                            .fixedSize()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .transition(.opacity)
                    .frame(height: self.shouldShowURLBar() ? 28 : 0)
                    .offset(y: self.shouldShowURLBar() ? 0 : -10)
                    .background(Color("URLBarColor"))
                    .animation(.easeOut(duration: 0.2))
                })
                .onAppear {
                    mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                        self.distanceOfMouseFromTopOfWindowFrame = size.height - event.locationInWindow.y
                        return event
                    }
                    
                    self.size = geometry.size
                    state.urlInputString = state.lastURL
                    
                    tryToLoadURLFromURLString()
                    hideWindowControls()
                }
                .onDisappear() {
                    if let monitor = mouseMonitor {
                        NSEvent.removeMonitor(monitor)
                    }
                }
                .onChange(of: self.distanceOfMouseFromTopOfWindowFrame) { newValue in
                    if newValue < 30 && newValue > 0 {
                        hovering = true
                    } else {
                        hovering = false
                    }
                }
                .onChange(of: geometry.size) { newSize in
                    size = newSize
                }
                .onChange(of: hovering) { newValue in
                    if newValue {
                        showWindowControls()
                    } else {
                        hideWindowControls()
                    }
                }
                .onChange(of: state.lastURL) { newValue in
                    tryToLoadURLFromURLString()
                }
        }
    }
    
    func tryToLoadURLFromURLString() {
        if !state.urlInputString.isEmpty {
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
    
    func shouldShowURLBar() -> Bool {
        return hovering || webViewStore.loading || state.urlInputString.isEmpty
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

class WebViewStore: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var loading = false
    
    let webView: WKWebView
    
    override init() {
        webView = WKWebView()
        super.init()
        
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading = false
    }
    
    func loadUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
            
            self.loading = true
        }
    }
}

struct WebView: NSViewRepresentable {
    let webView: WKWebView
    
    func makeNSView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.setValue(false, forKey: "drawsBackground")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(store: webView.navigationDelegate as? WebViewStore)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private let store: WebViewStore?
        
        init(store: WebViewStore?) {
            self.store = store
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            store?.loading = false
        }
    }
}

let DEFAULT_HTML_STRING = """

<style>
    * {
        background-color: maroon;
        color: white;
        font-family: "Helvetica Neue";
    }

    .centered {
                display: flex;
                justify-content: center;
                align-items: center;
                position: fixed;
                top: 0;
                left: 0;
                bottom: 0;
                right: 0;
    }
    .content {
        text-align: center;
        padding: 20px;
    }

</style>

<body>
    <div class="centered">
            <div class="content">
                <h1>Welcome to Poppy!</h1>
                <p>Keep your single most important bookmark on top of everything else.</p>
            </div>
        </div>
</body>
"""
