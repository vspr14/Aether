//import SwiftUI
//import WebKit
//
//struct WebView: NSViewRepresentable {
//    let webView: WKWebView
//    @Binding var url: URL
//    @ObservedObject var webViewModel: WebViewModel
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self, webViewModel: webViewModel)
//    }
//
//    func makeNSView(context: Context) -> WKWebView {
//        let request = URLRequest(url: url)
//        webView.navigationDelegate = context.coordinator
//        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
//        webView.load(request)
//        return webView
//    }
//
//    func updateNSView(_ nsView: WKWebView, context: Context) {
//        // Only load the request if the URL has changed
//        if nsView.url?.absoluteString != url.absoluteString {
//            let request = URLRequest(url: url)
//            nsView.load(request)
//        }
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: WebView
//        var webViewModel: WebViewModel
//        var lastLoadedURL: String?
//
//        init(_ parent: WebView, webViewModel: WebViewModel) {
//            self.parent = parent
//            self.webViewModel = webViewModel
//        }
//
//        // Method that gets called when navigation finishes (page fully loaded)
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            // Check if the URL has actually changed
//            if let currentURL = webView.url?.absoluteString {
//                if currentURL != lastLoadedURL {
//                    lastLoadedURL = currentURL
//                    DispatchQueue.main.async {
//                        self.webViewModel.currentURL = currentURL
//                    }
//                }
//            }
//        }
//    }
//}
