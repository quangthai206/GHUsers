//
//  UserService.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation
import CoreData

public final class UserService: UserServiceProtocol {
  private let apiClient: GitHubAPIClientProtocol
  private let coreDataClient: CoreDataClientProtocol
  
  public init(
    apiClient: GitHubAPIClientProtocol,
    coreDataClient: CoreDataClientProtocol
  ) {
    self.apiClient = apiClient
    self.coreDataClient = coreDataClient
  }
}

// MARK: - Methods

extension UserService {
  public func fetchRemoteUsers(since: Int?, perPage: Int) async throws -> [GitHubUser] {
    let users = try await apiClient.fetchUsers(since: since, perPage: perPage)
    coreDataClient.save(users: users)
    return users
  }
  
  public func makeFetchedResultsController() -> NSFetchedResultsController<CachedUser> {
    coreDataClient.makeFetchedResultsController()
  }
  
  public func fetchUserDetails(with login: String) async throws -> GitHubUser {
    let userDetails = try await apiClient.fetchUserDetails(with: login)
    coreDataClient.save(users: [userDetails])
    return userDetails
  }
}
