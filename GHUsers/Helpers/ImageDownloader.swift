//
//  ImageDownloader.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit

final class ImageDownloader {
  static let shared = ImageDownloader()
  private let cache = NSCache<NSURL, UIImage>()
  
  private init() {}
  
  /// Downloads an image from the provided URL, using cache if available.
  func download(from url: URL) async throws -> UIImage {
    if let cached = cache.object(forKey: url as NSURL) {
      return cached
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
      throw URLError(.cannotDecodeContentData)
    }
    
    cache.setObject(image, forKey: url as NSURL)
    return image
  }
}
