//
//  WebViewStore.swift
//  Poppy
//
//  Created by Alexis Rondeau on 03.06.23.
//

import Foundation
import WebKit
import SwiftUI

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
            
            let userJS = """
// Verify JS can be executed: document.body.style = "background-color: blue !important;";
"""
            let jsScript = WKUserScript(source: userJS, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(jsScript)
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
                <div id="demo">
                    DEMO
                </div>

                <h1>Welcome to Poppy!</h1>
                <p>Keep your single most important bookmark on top of everything else.</p>
            </div>
    </div>
</body>
"""
