//
//  CoreDataClient.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation
import CoreData

public final class CoreDataClient: CoreDataClientProtocol {
  private let coreDataStack: CoreDataStack
  
  public init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }
}

// MARK: - Methods

extension CoreDataClient {
  public func save(users: [GitHubUser]) {
    let context = coreDataStack.context
    context.perform {
      for user in users {
        CachedUser.insertIfNeeded(from: user, in: context)
      }
      try? context.save()
    }
  }
  
  public func makeFetchedResultsController() -> NSFetchedResultsController<CachedUser> {
    let request: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    
    return NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: coreDataStack.context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
  }
}
