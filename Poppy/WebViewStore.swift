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
        background-color: #fff;
        color: #444;
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
        background-color: lightyellow;
        border-radius: 8px;
    }
    
    .big {
        font-size: 28px;
    }

    .subheadline {
        font-size: 24px;
        line-height: 140%;
    }

    img#appIcon {
        width: 128px;
        height: 128px;
    }

    h1, h2, h3, p {
        padding: 4px;
    }

    code {
        margin: 8px;
        padding: 16px;
        border-radius: 8px;
        background-color: #efefef;
        border: 1px solid #ccc;
    }

    span.key {
        border-radius: 8px;
        background-color: #111;
        color: white;
        padding: 8px;
    }

    .special {
        background-color: #333 !important;
    }


</style>

<body>
    <div class="top">
        <p>
            <span class="big">↑</span>
            <div class="highlight">Enter your URL here</div>
        </p>
    </div>
    <div class="centered">
            <div class="content">
                <img id="appIcon" src="https://github.com/akaalias/Poppy/blob/main/Icon-265.png?raw=true"/>

                <h1>Welcome to Poppy!</h1>

                <p class="subheadline">Keep your single most important bookmark on top of everything else.</p>

                <br/>
                <br/>

                <h3>Hot Tip 1: Briefly Swipe Away</h3>
                <p>I usually have Poppy to the right side of my screen. And sometimes it's on top of something that I want to see. To briefly swipe it away, I use this:</p>

                <br/>

                <p><code><span class="key">Control</span> + <span class="key">Option</span> + <span class="key">Command</span> + <span class="key special">O</span></code></p>

                <br/>
                <br/>

                <h3>Hot Tip 2: Pin and Unpin</h3>
                <p>By default, Poppy is always on top. It's kind of its raison d'etre. But sometimes, when I really don't need Poppy, I use this hotkey to unpin it from the top.</p>

                <br/>

                <p><code><span class="key">Control</span> + <span class="key">Option</span> + <span class="key">Command</span> + <span class="key special">P</span></code></p>

            </div>
    </div>
</body>
"""
