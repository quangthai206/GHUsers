//
//  UserDetailsController.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import UIKit
import GHUsersCore

final class UserDetailsController: UIViewController {
  var viewModel: UserDetailsViewModelProtocol!
  
  @IBOutlet private(set) var userCardView: UserCardView!
  @IBOutlet private(set) var followInfoStackView: UIStackView!
  @IBOutlet private(set) var followersCountLabel: UILabel!
  @IBOutlet private(set) var followingCountLabel: UILabel!
  @IBOutlet private(set) var blogInfoView: UIView!
  @IBOutlet private(set) var blogLinkTextView: UITextView!
}

// MARK: - Lifecycle

extension UserDetailsController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    bind()
    refresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.largeTitleDisplayMode = .never
  }
}

// MARK: - Setup

private extension UserDetailsController {
  func setup() {
    title = "User Details"
  }
}

// MARK: - Bindings

private extension UserDetailsController {
  func bind() {
    
  }
}

// MARK: - Refresh

private extension UserDetailsController {
  func refresh() {
    userCardView.viewModel = viewModel.cardViewVM
    refreshLabels()
    refreshTextView()
  }
  
  func refreshLabels() {
    followInfoStackView.isHidden = false
    followersCountLabel.text = viewModel.followersCountText
    followingCountLabel.text = viewModel.followingCountText
  }
  
  func refreshTextView() {
    blogInfoView.isHidden = viewModel.isBlogInfoHidden
    blogLinkTextView.configureAsLink(viewModel.blogURL)
  }
}
