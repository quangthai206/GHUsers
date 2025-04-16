//
//  HomeNavCoordinator.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit
import GHUsersCore

final class HomeNavCoordinator: NavCoordinator {
  private let config: AppConfigProtocol
  private let userService: UserServiceProtocol
  
  init(
    navRouter: NavRouterProtocol,
    config: AppConfigProtocol = App.shared.config,
    userService: UserServiceProtocol = App.shared.user
  ) {
    self.config = config
    self.userService = userService
    
    super.init(navRouter: navRouter)
  }
  
  override func start() {
    setRootToUserListScene()
  }
}

// MARK: - UserList Scene

extension HomeNavCoordinator {
  func setRootToUserListScene() {
    let vm = UserListViewModel(
      userService: userService,
      config: config
    )
    
    let storyboard = UIStoryboard(name: "UserList", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: UserListController.storyboardID) as! UserListController
    vc.viewModel = vm
    
    vc.onUserItemTap = trigger(type(of: self).pushUserDetailsScene)
    
    navRouter.setRoot(vc, animated: true)
  }
}

// MARK: - UserDetails Scene

extension HomeNavCoordinator {
  func pushUserDetailsScene(user: GitHubUser) {
    let vm = UserDetailsViewModel(
      user: user,
      userService: userService
    )
    
    let storyboard = UIStoryboard(name: "UserDetails", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: UserDetailsController.storyboardID) as! UserDetailsController
    vc.viewModel = vm
    
    navRouter.push(vc, animated: true)
  }
}
