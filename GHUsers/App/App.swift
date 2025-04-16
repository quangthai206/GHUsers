//
//  App.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import UIKit
import GHUsersCore

class App {
  static let shared = App()
  
  private(set) var config: AppConfigProtocol!
  
  private(set) var api: GitHubAPIClientProtocol!
  
  private(set) var coreData: CoreDataClientProtocol!
  
  // MARK: User
  
  private(set) var user: UserServiceProtocol!
  
  // MARK: Initialization
  
  private init() {}
  
  func bootstrap(
    with application: UIApplication,
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    config = AppConfig()
    
    api = GitHubAPIClient(
      session: .shared,
      baseURL: URL(string: config.baseUrl)!
    )
    
    coreData = CoreDataClient(coreDataStack: CoreDataStack.shared)
    
    user = UserService(
      apiClient: api,
      coreDataClient: coreData
    )
  }
}
