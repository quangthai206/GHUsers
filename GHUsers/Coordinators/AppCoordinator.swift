//
//  AppCoordinator.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
  private let windowRouter: WindowRouterProtocol
  
  init(windowRouter: WindowRouterProtocol) {
    self.windowRouter = windowRouter
  }
  
  override func start() {
    startHomeNavCoordinator()
  }
}

// MARK: - Home Coordinator

extension AppCoordinator {
  func startHomeNavCoordinator() {
    let nc = UINavigationController()
    windowRouter.setRoot(nc, animated: false)
    
    let navRouter = NavRouter(navigationController: nc)
    let coordinator = HomeNavCoordinator(navRouter: navRouter)
    
    startChild(coordinator)
  }
}
