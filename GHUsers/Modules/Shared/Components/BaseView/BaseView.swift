//
//  BaseView.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit

class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    prepare()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    // Do not call `prepare` method yet. Wait until the view is
    // completely loaded from a nib archive.
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    prepare()
  }

  /// Called after the view is initialized or loaded from a nib archive.
  ///
  /// Subclasses can override this method to provide their own implementation. Don't forget to
  /// call super somewhere in the function.
  func prepare() {
    // Do additional setups here.
  }
}

/// A container view that allows touches to pass through to its surface areas other than those
/// occupied by its `touchableViews`, enabling views behind it to respond.
class PartiallyTouchableView: BaseView {
  @IBOutlet var touchableViews: [UIView]?

  override func prepare() {
    super.prepare()

    backgroundColor = .clear
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let view = super.hitTest(point, with: event) else { return nil }
    guard let touchableViews, touchableViews.contains(view) else { return nil }
    return view
  }
}
