//
//  UITextView+LinkConfiguration.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import UIKit

extension UITextView {
  func configureAsLink(_ url: URL?) {
    guard let linkText = url?.absoluteString else {
      return
    }
    
    let attributedString = NSMutableAttributedString(string: linkText)
    attributedString.addAttribute(
      .link,
      value: linkText,
      range: NSRange(location: 0, length: linkText.count)
    )
    
    self.attributedText = attributedString
    self.isEditable = false
    self.isSelectable = true
    self.isScrollEnabled = false
    self.dataDetectorTypes = [.link]
    self.textAlignment = .left
    self.textColor = .systemBlue
    self.backgroundColor = .clear
    self.textContainerInset = .zero
    self.textContainer.lineFragmentPadding = 0
  }
}
