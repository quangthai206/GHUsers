//
//  CachedUser+CoreDataProperties.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//
//

import Foundation
import CoreData

extension CachedUser {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUser> {
    return NSFetchRequest<CachedUser>(entityName: "CachedUser")
  }
  
  @NSManaged public var id: Int64
  @NSManaged public var login: String
  @NSManaged public var avatarUrl: String
  @NSManaged public var htmlUrl: String
  @NSManaged public var name: String?
  @NSManaged public var location: String?
  @NSManaged public var blogLink: String?
  @NSManaged public var followers: Int64
  @NSManaged public var following: Int64
}

extension CachedUser : Identifiable {}
