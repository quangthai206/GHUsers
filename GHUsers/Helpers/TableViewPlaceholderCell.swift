//
//  TableViewPlaceholderCell.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit

/// A UITableViewCell used as a placeholder for an existing custom view.
class TableViewPlaceholderCell<MainView>: UITableViewCell where MainView: UIView {
  private(set) var mainView: MainView!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    backgroundColor = .clear
    
    mainView = .init(frame: .zero)
    contentView.addSubview(mainView)
  }
  
  func setupConstraints() {
    mainView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
      mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
