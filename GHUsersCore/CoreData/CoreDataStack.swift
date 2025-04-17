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
  
  // In-Memory Core Data Stack for Testing
  public static func inMemory() -> CoreDataStack {
    let container = PersistentContainer(name: "GHUsers")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    
    container.persistentStoreDescriptions = [description]
    
    container.loadPersistentStores { (_, error) in
      if let error {
        fatalError("Failed to load in-memory Core Data store: \(error)")
      }
    }
    
    let stack = CoreDataStack()
    stack.persistentContainer = container
    return stack
  }
}
