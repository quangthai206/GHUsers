//
//  HomeNavCoordinator.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit
import GHUsersCore

final class HomeNavCoordinator: NavCoordinator {
  override func start() {
    setRootToUserListScene()
  }
}

// MARK: - UserList Scene

extension HomeNavCoordinator {
  func setRootToUserListScene() {
    let vm = UserListViewModel()
    
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
    let vm = UserDetailsViewModel(user: user)
    
    let storyboard = UIStoryboard(name: "UserDetails", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: UserDetailsController.storyboardID) as! UserDetailsController
    vc.viewModel = vm
    
    navRouter.push(vc, animated: true)
  }
}
