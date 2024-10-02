import SwiftUI
import WebKit

// WebViewModel: Manages the WKWebView logic and provides navigation handling
class WebViewModel: ObservableObject {
    @Published var urlString: String = "" // Bind this to the TextField
    let webView: WKWebView

    init() {
        webView = WKWebView(frame: .zero)
    }

    // Load a URL string in the web view
    func loadUrl() {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }

    // Method to update TextField with current WebView URL
    func updateUrlFromWebView() {
        if let currentUrl = webView.url {
            urlString = currentUrl.absoluteString // Convert URL to string and update
        }
    }
}


// SwiftUI WebView struct: Represents the WebView in SwiftUI for macOS
struct WebView: NSViewRepresentable {
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}
}

// TabViewModel: Manages multiple tabs
class TabViewModel: ObservableObject {
    @Published var tabs: [WebViewModel] = [WebViewModel()] // List of tabs
    @Published var selectedTabIndex: Int = 0

    // Add a new tab
    func addTab() {
        let newTab = WebViewModel()
        tabs.append(newTab)
        selectedTabIndex = tabs.count - 1 // Automatically switch to the new tab
    }

    // Close a tab
    func closeTab(at index: Int) {
        guard tabs.count > 1 else { return } // Prevent closing the last tab
        tabs.remove(at: index)
        selectedTabIndex = max(0, selectedTabIndex - 1) // Switch to a valid tab
    }
}

// ContentView: The main view which contains the TabView and WebView for each tab
struct ContentView: View {
    @StateObject var tabViewModel = TabViewModel()

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    tabViewModel.tabs[tabViewModel.selectedTabIndex].webView.goBack()
                }) {
                    Image(systemName: "arrow.left")
                }
                .disabled(!tabViewModel.tabs[tabViewModel.selectedTabIndex].webView.canGoBack)

                Button(action: {
                    tabViewModel.tabs[tabViewModel.selectedTabIndex].webView.goForward()
                }) {
                    Image(systemName: "arrow.right")
                }
                .disabled(!tabViewModel.tabs[tabViewModel.selectedTabIndex].webView.canGoForward)

                TextField("Enter URL", text: $tabViewModel.tabs[tabViewModel.selectedTabIndex].urlString, onCommit: {
                    tabViewModel.tabs[tabViewModel.selectedTabIndex].loadUrl()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                Button(action: {
                    tabViewModel.tabs[tabViewModel.selectedTabIndex].loadUrl()
                }) {
                    Text("Go")
                }

                Button(action: {
                    tabViewModel.addTab() // Add a new tab
                }) {
                    Text("New Tab")
                }
            }
            .padding()

            TabView(selection: $tabViewModel.selectedTabIndex) {
                ForEach(Array(zip(tabViewModel.tabs.indices, tabViewModel.tabs)), id: \.0) { index, tab in
                    WebView(webView: tab.webView)
                        .frame(minHeight: 600)
                        .tabItem {
                            Text("Tab \(index + 1)") // Display tab title
                        }
                        .tag(index) // Tag each tab to switch between them
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
