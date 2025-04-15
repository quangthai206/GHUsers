//
//  UserCardView.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit
import GHUsersCore

final class UserCardView: BaseView, NibLoadable {
  var viewModel: UserCardViewModelProtocol! {
    didSet { refresh() }
  }
  
  @IBOutlet private(set) var contentView: UIView!
  @IBOutlet private(set) var containerView: UIView!
  @IBOutlet private(set) var avatarImageView: UIImageView!
  @IBOutlet private(set) var nameLabel: UILabel!
  @IBOutlet private(set) var linkTextView: UITextView!
  @IBOutlet private(set) var locationView: UIStackView!
  @IBOutlet private(set) var locationLabel: UILabel!
  
  override func prepare() {
    loadNib()
    setup()
  }
}

// MARK: - Setup

private extension UserCardView {
  func setup() {
    setupImageView()
    setupShadow()
  }
  
  func setupImageView() {
    avatarImageView.layer.borderWidth = 1
    avatarImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
    avatarImageView.tintColor = .lightGray
  }
  
  func setupShadow() {
    containerView.layer.cornerRadius = 8
    containerView.layer.masksToBounds = true;
    containerView.applyShadow(
      color: .black,
      opacity: 0.15,
      offSet: CGSize(width: 0, height: 2),
      radius: 2
    )
  }
}

// MARK: - Refresh

private extension UserCardView {
  func refresh() {
    refreshImageView()
    refreshLabels()
    refreshTextView()
  }
  
  func refreshImageView() {
    avatarImageView.loadImage(
      from: viewModel.avatarURL,
      placeholder: UIImage(systemName: "person.crop.circle")
    )
  }
  
  func refreshLabels() {
    nameLabel.text = viewModel.nameText
    locationLabel.text = viewModel.locationText
    locationView.isHidden = viewModel.isLocationHidden
  }
  
  func refreshTextView() {
    linkTextView.isHidden = viewModel.isLinkURLHidden
    linkTextView.configureAsLink(viewModel.linkURL)
  }
}
