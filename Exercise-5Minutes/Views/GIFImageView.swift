import SwiftUI
import SDWebImageSwiftUI

struct GIFImageView: View {
    let gifURL: URL
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                AnimatedImage(url: gifURL)
                    .resizable()
                    .indicator(SDWebImageActivityIndicator.medium)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(height: 200)
                    .overlay {
                        if error != nil {
                            VStack {
                                Image(systemName: "figure.run.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                                
                                Text(error?.localizedDescription ?? "Failed to load")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
            }
        }
        .onAppear {
            isLoading = true
            // Start loading
            SDWebImageManager.shared.loadImage(
                with: gifURL,
                options: [],
                progress: nil
            ) { (image, data, error, cacheType, finished, url) in
                isLoading = false
                if let error = error {
                    self.error = error
                    print("DEBUG: Failed to load GIF: \(error.localizedDescription)")
                } else if finished {
                    print("DEBUG: Successfully loaded GIF from: \(url?.absoluteString ?? "")")
                }
            }
        }
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