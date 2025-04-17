//
//  UserDetailsController.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import UIKit
import GHUsersCore
import Combine

final class UserDetailsController: UIViewController {
  var viewModel: UserDetailsViewModelProtocol!
  
  @IBOutlet private(set) var userCardView: UserCardView!
  @IBOutlet private(set) var followInfoStackView: UIStackView!
  @IBOutlet private(set) var followersCountLabel: UILabel!
  @IBOutlet private(set) var followingCountLabel: UILabel!
  @IBOutlet private(set) var blogInfoView: UIView!
  @IBOutlet private(set) var blogLinkTextView: UITextView!
  @IBOutlet private(set) var activityIndicator: UIActivityIndicatorView!
  
  private var cancellables = Set<AnyCancellable>()
}

// MARK: - Lifecycle

extension UserDetailsController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    bind()
    fetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.largeTitleDisplayMode = .never
  }
}

// MARK: - Setup

private extension UserDetailsController {
  func setup() {
    title = viewModel.userLogin
    configureAccessibilityIdentifiers()
    
    // Display user card view
    refresh()
  }
  
  func configureAccessibilityIdentifiers() {
    userCardView.accessibilityIdentifier = "userDetailsCardView"
    followersCountLabel.accessibilityIdentifier = "followersCountLabel"
    followingCountLabel.accessibilityIdentifier = "followingCountLabel"
  }
}

// MARK: - Bindings

private extension UserDetailsController {
  func bind() {
    viewModel.reloadPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.activityIndicator.stopAnimating()
        self?.refresh()
      }
      .store(in: &cancellables)
    
    viewModel.errorPublisher
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] errorMessage in
        self?.activityIndicator.stopAnimating()
        self?.showErrorAlert(message: errorMessage)
      }
      .store(in: &cancellables)
  }
}

// MARK: - Helpers

private extension UserDetailsController {
  func fetchData() {
    activityIndicator.startAnimating()
    viewModel.fetchUserDetails()
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
