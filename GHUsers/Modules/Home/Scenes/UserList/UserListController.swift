//
//  UserListController.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit
import Combine
import GHUsersCore

final class UserListController: UIViewController {
  var viewModel: UserListViewModelProtocol!
  
  var onUserItemTap: SingleResult<CachedUser>?
  
  @IBOutlet private(set) var tableView: UITableView!
  @IBOutlet private(set) var activityIndicator: UIActivityIndicatorView!
  
  private var cancellables = Set<AnyCancellable>()
}

// MARK: - Lifecycle

extension UserListController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationItem.largeTitleDisplayMode = .always
  }
}

// MARK: - Setup

private extension UserListController {
  func setup() {
    setupNavigation()
    setupTableView()
    configureAccessibilityIdentifiers()
  }
  
  func setupNavigation() {
    title = "GHUsers"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(
      UserTableViewCell.self,
      forCellReuseIdentifier: UserTableViewCell.reuseIdentifier
    )
  }
  
  func configureAccessibilityIdentifiers() {
    tableView.accessibilityIdentifier = "usersTableView"
  }
}

// MARK: - Bindings

private extension UserListController {
  func bind() {
    viewModel.reloadPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.activityIndicator.stopAnimating()
        self?.tableView.reloadData()
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

// MARK: - UITableViewDataSource & Delegate

extension UserListController: UITableViewDataSource, UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    viewModel.numberOfUsers
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell
    else {
      return UITableViewCell()
    }
    
    let vm = viewModel.itemCellVM(at: indexPath.row)
    cell.mainView.viewModel = vm
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    if let user = viewModel.user(at: indexPath.row) {
      onUserItemTap?(user)
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let frameHeight = scrollView.frame.size.height
    
    let isAtBottom = offsetY > contentHeight - frameHeight
    if isAtBottom && !activityIndicator.isAnimating {
      activityIndicator.startAnimating()
      viewModel.fetchUsersIfNeeded()
    }
  }
}
