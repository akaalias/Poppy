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
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    AppNavigationPlaceholdersView()
                    
                    TextField("Enter your URL", text: $state.urlInputString, onCommit: {
                        self.tryToLoadURLFromURLString()
                    })
                    .font(.body)
                    .textFieldStyle(.plain)
                    .foregroundColor(Color("URLBarText"))
                    .opacity(self.hovering ? 1 : 0.5)
                    .transition(.opacity)
                    .animation(.easeOut)
                    
                    if webViewStore.loading {
                        ProgressView()
                            .controlSize(.small)
                            .opacity(self.hovering ? 1 : 0.5)
                            .transition(.opacity)
                            .animation(.easeOut)

                    }
                    
                    Spacer()
                    
                    URLBarNavigationItems()
                        .opacity(self.hovering ? 1 : 0.5)
                        .transition(.opacity)
                        .animation(.easeOut)

                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Color("URLBarColor"))
                .onHover(perform: { hover in
                    self.hovering = hover
                })
                
                WebView(webView: webViewStore.webView)
            }
            .onAppear {
                state.urlInputString = state.lastURL
                tryToLoadURLFromURLString()
                hideWindowControls()
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
        background-color: blue;
        color: white;
        font-family: "Helvetica Neue";
        margin: 0px;
        padding: 0px;
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
