//
//  ImageLoader.swift
//  CoreModule
//
//  Created by Mai Hassen on 02/12/2024.
//

import Combine
import SwiftUI



public class ImageLoader: ObservableObject {
    @Published public var image: UIImage? = nil
    public var cancellable: AnyCancellable?
    public init(image: UIImage? = nil, cancellable: AnyCancellable? = nil) {
        self.image = image
        self.cancellable = cancellable
    }
    public func loadImage(from url: URL) {
        // Check if the image is already cached
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
           let cachedImage = UIImage(data: cachedResponse.data) {
            self.image = cachedImage
            return
        }

        // Fetch the image from the network
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage? in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return UIImage(data: data)
            }
            .catch { error -> Just<UIImage?> in
                print("Image loading failed with error: \(error)")
                return Just(nil) // Return nil if an error occurs
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.image = image
            }

    }

  public func cancel() {
        cancellable?.cancel()
    }
}

