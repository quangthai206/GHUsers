//
//  UserServiceProtocol.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation
import CoreData

public protocol UserServiceProtocol {
  func fetchRemoteUsers(since: Int?, perPage: Int) async throws -> [GitHubUser]
  func fetchUserDetails(with login: String) async throws -> GitHubUser
  func makeFetchedResultsController() -> NSFetchedResultsController<CachedUser>
}
