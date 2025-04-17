//
//  MockGitHubAPIClient.swift
//  GHUsersCoreTests
//
//  Created by Quang Thai on 17/4/25.
//

@testable import GHUsersCore

final class MockGitHubAPIClient: GitHubAPIClientProtocol {
  var usersToReturn: [GitHubUser] = []
  var userDetailToReturn: GitHubUser?
  var shouldFail = false
  
  func fetchUsers(since userId: Int?, perPage: Int) async throws -> [GitHubUser] {
    if shouldFail {
      throw URLError(.badServerResponse)
    }
    return usersToReturn
  }
  
  func fetchUserDetails(with login: String) async throws -> GitHubUser {
    if shouldFail {
      throw URLError(.badServerResponse)
    }
    guard let user = userDetailToReturn else {
      throw URLError(.badServerResponse)
    }
    return user
  }
}
