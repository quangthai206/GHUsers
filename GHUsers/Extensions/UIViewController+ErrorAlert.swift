//
//  UIViewController+ErrorAlert.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import UIKit

extension UIViewController {
  func showErrorAlert(message: String?) {
    guard let message else { return }
    
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
