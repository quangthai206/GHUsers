//
//  UserService.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation

public final class UserService: UserServiceProtocol {
  private let api: GitHubAPIClientProtocol
  
  public init(api: GitHubAPIClientProtocol) {
    self.api = api
  }
}

// MARK: - Methods

extension UserService {
  public func fetchUsers(since userId: Int?, perPage: Int) async throws -> [GitHubUser] {
    try await api.fetchUsers(since: userId, perPage: perPage)
  }
  
  public func fetchUserDetails(with login: String) async throws -> GitHubUser {
    try await api.fetchUserDetails(with: login)
  }
}
