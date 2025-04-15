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
  
  var onUserItemTap: SingleResult<GitHubUser>?
  
  @IBOutlet private(set) var tableView: UITableView!
  
  private var cancellables = Set<AnyCancellable>()
}

// MARK: - Lifecycle

extension UserListController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    bind()
    viewModel.fetchUsers()
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
}

// MARK: - Bindings

private extension UserListController {
  func bind() {
    viewModel.reloadPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        guard let self else { return }
        self.tableView.reloadData()
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
    onUserItemTap?(viewModel.user(at: indexPath.row))
  }
}
