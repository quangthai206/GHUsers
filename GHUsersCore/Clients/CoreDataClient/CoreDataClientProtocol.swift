//
//  CoreDataClientProtocol.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import CoreData

public protocol CoreDataClientProtocol {
  func save(users: [GitHubUser])
  func makeFetchedResultsController() -> NSFetchedResultsController<CachedUser>
}
