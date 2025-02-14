import SwiftUI
import SDWebImageSwiftUI

struct GIFImageView: View {
    let gifURL: URL
    @State private var isLoading = false
    @State private var error: Error?
    
    // MARK: - Constants
    private enum Layout {
        static let minimumTapTarget: CGFloat = 44 // Apple minimum tap target size
        static let spacing: CGFloat = 12 // Consistent spacing
        static let imageHeight: CGFloat = 250 // Taller for better visibility
        static let iconSize: CGFloat = 60
        static let cornerRadius: CGFloat = 12
    }
    
    var body: some View {
        VStack(spacing: Layout.spacing) {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(height: Layout.imageHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(Layout.cornerRadius)
            } else {
                AnimatedImage(url: gifURL)
                    .resizable()
                    .indicator(SDWebImageActivityIndicator.medium)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(height: Layout.imageHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(Layout.cornerRadius)
                    .overlay {
                        if error != nil {
                            errorView
                        }
                    }
                    // Make the entire view tappable for retry
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if error != nil {
                            retryLoading()
                        }
                    }
            }
        }
        .padding(.horizontal)
        .onAppear {
            startLoading()
        }
    }
    
    // MARK: - Subviews
    private var errorView: some View {
        VStack(spacing: Layout.spacing) {
            Image(systemName: "figure.run.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Layout.iconSize, height: Layout.iconSize)
                .foregroundColor(.gray)
            
            Text(error?.localizedDescription ?? "Failed to load")
                .font(.callout) // At least 11pt as per guidelines
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retryLoading) {
                Text("Tap to retry")
                    .foregroundColor(.blue)
                    .padding()
                    // Ensure minimum tap target size
                    .frame(minWidth: Layout.minimumTapTarget, 
                           minHeight: Layout.minimumTapTarget)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(Layout.cornerRadius)
    }
    
    // MARK: - Methods
    private func startLoading() {
        isLoading = true
        error = nil
        
        SDWebImageManager.shared.loadImage(
            with: gifURL,
            options: [.retryFailed, .fromCacheOnly],
            progress: nil
        ) { (image, data, error, cacheType, finished, url) in
            isLoading = false
            if let error = error {
                self.error = error
                print("DEBUG: Failed to load GIF: \(error.localizedDescription)")
            } else if finished {
                print("DEBUG: Successfully loaded GIF from \(cacheType): \(url?.absoluteString ?? "")")
            }
        }
    }
    
    private func retryLoading() {
        startLoading()
    }
}

// MARK: - UIImage Extension for GIF
extension UIImage {
    class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("DEBUG: Failed to create image source")
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        guard count > 1 else {
            print("DEBUG: Not an animated image")
            return UIImage(data: data)
        }
        
        var images = [UIImage]()
        var duration = 0.0
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                   let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                   let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                    duration += delayTime
                }
            }
        }
        
        let finalDuration = duration > 0 ? duration : Double(count) * 0.1
        
        return UIImage.animatedImage(with: images, duration: finalDuration)
    }
} 