//
//  UIImageView+LoadImage.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit

public extension UIImageView {
  /// Loads an image asynchronously from a URL into the UIImageView.
  /// Falls back to a placeholder image on failure.
  func loadImage(from url: URL?, placeholder: UIImage? = nil) {
    self.image = placeholder
    
    guard let url else { return }
    
    Task {
      do {
        let image = try await ImageDownloader.shared.download(from: url)
        DispatchQueue.main.async {
          self.image = image
        }
      } catch {
        DispatchQueue.main.async {
          self.image = placeholder
        }
      }
    }
  }
}
