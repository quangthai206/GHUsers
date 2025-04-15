//
//  UIView+Shadow.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit

extension UIView {
  func applyShadow(
    color: UIColor,
    opacity: Float = 0.5,
    offSet: CGSize = CGSize(width: -1, height: 1),
    radius: CGFloat = 1
  ) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
//    var _frame = frame
//    _frame.origin = .zero
//    
//    layer.shadowPath = UIBezierPath(roundedRect: _frame, cornerRadius: layer.cornerRadius).cgPath
  }
}
