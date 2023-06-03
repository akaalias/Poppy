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
                
                if webViewStore.loading {
                    ProgressView()
                        .controlSize(.small)
                }
            })
            
            ToolbarItemGroup(placement: .automatic, content: {
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
                
                Spacer()            })
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

    .top {
        position: absolute;
        top: 0px;
        left: 20px;
        z-index: 100;
        text-align: center;
    }

    .highlight {
        padding: 8px;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
    }
    
    .big {
        font-size: 28px;
    }

</style>

<body>
    <div class="top">
        <p>
            <span class="big">↑</span>
            <div class="highlight">Enter your URL here!</div>
        </p>
    </div>
    <div class="centered">
            <div class="content">
                <h1>Welcome to Poppy!</h1>
                <p>Keep your single most important bookmark on top of everything else.</p>
            </div>
        </div>
</body>
"""
