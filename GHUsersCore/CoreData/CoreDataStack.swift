//
//  CoreDataStack.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import CoreData

class PersistentContainer: NSPersistentContainer {}

public final class CoreDataStack {
  public static let shared = CoreDataStack()
  
  lazy var persistentContainer: PersistentContainer = {
    let container = PersistentContainer(name: "GHUsers")
    container.loadPersistentStores { _, error in
      if let error {
        fatalError(error.localizedDescription)
      }
    }
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.automaticallyMergesChangesFromParent = true
    return container
  }()
  
  var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  func saveContext() {
    guard context.hasChanges else { return }
    try? context.save()
  }
}
