//
//  ImageView.swift
//  BlueMarble
//
//
//

// Code from:  https://stackoverflow.com/questions/60677622/how-to-display-image-from-a-url-in-swiftui

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    
    // PassthroughSubject broadcasts elements to downstream subscribers
    var didChange = PassthroughSubject<Data, Never>()
    
    // When data is set/changed, the PassthroughSubject sends the data
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    // Initializer for this ImageLoader class, taking in a URL string
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        
        // We need to fetch the image data into memory
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            // Use async because it lets the calling queue continue without waiting for the
            // dispatched action to be executed.
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

// ImageView struct -- returns a View of the image.  Notice the Image() element inside our body
struct ImageView: View {
    
    @ObservedObject var imageLoader:ImageLoader

    // State variable to store off the UIImage()
    @State var image:UIImage = UIImage()

    // Initialize with the url string
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {

            // Output the image
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height:100)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
