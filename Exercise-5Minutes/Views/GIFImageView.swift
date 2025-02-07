import SwiftUI
import WebKit

struct GIFImageView: UIViewRepresentable {
    let gifName: String
    
    // Coordinator to handle fallback image
    class Coordinator: NSObject {
        var parent: GIFImageView
        var fallbackImage: UIImage?
        
        init(_ parent: GIFImageView) {
            self.parent = parent
            self.fallbackImage = UIImage(systemName: "figure.run.circle")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Try to load GIF from asset catalog
        if let gifData = NSDataAsset(name: gifName)?.data {
            // Debug log for GIF loading
            print("DEBUG: Loading GIF from asset catalog: \(gifName)")
            
            let base64String = gifData.base64EncodedString()
            
            let html = """
            <html>
            <body style="margin: 0; background: transparent;">
            <img src="data:image/gif;base64,\(base64String)" style="width: 100%; height: 100%; object-fit: contain;">
            </body>
            </html>
            """
            
            webView.loadHTMLString(html, baseURL: nil)
        } else {
            print("DEBUG: GIF not found in asset catalog: \(gifName), showing fallback image")
            
            // Show fallback image using HTML
            if let fallbackImage = context.coordinator.fallbackImage {
                let imageData = fallbackImage.pngData()
                let base64String = imageData?.base64EncodedString() ?? ""
                
                let html = """
                <html>
                <body style="margin: 0; background: transparent; display: flex; justify-content: center; align-items: center;">
                    <div style="text-align: center;">
                        <img src="data:image/png;base64,\(base64String)" style="width: 60%; height: 60%; object-fit: contain;">
                        <p style="font-family: -apple-system; color: gray; margin-top: 10px;">Exercise animation coming soon</p>
                    </div>
                </body>
                </html>
                """
                
                webView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension GIFImageView.Coordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("DEBUG: Failed to load GIF: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("DEBUG: Failed to load GIF: \(error.localizedDescription)")
    }
} 