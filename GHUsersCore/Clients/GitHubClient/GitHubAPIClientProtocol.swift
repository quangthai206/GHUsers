//
//  GitHubAPIClientProtocol.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation

public protocol GitHubAPIClientProtocol {
  func fetchUsers(since userId: Int?, perPage: Int) async throws -> [GitHubUser]
  func fetchUserDetails(with login: String) async throws -> GitHubUser
}
