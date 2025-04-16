//
//  CachedUser+Helpers.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import CoreData

extension CachedUser {
  func update(from user: GitHubUser) {
    id = Int64(user.id)
    login = user.login
    name = user.name
    location = user.location
    avatarUrl = user.avatarURL.absoluteString
    htmlUrl = user.htmlURL.absoluteString
    blogLink = user.blogLink
    followers = Int64(user.followers ?? 0)
    following = Int64(user.following ?? 0)
  }
  
  static func insertIfNeeded(from user: GitHubUser, in context: NSManagedObjectContext) {
    let request: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
    request.predicate = NSPredicate(format: "id == %d", user.id)
    request.fetchLimit = 1
    
    if let existing = (try? context.fetch(request))?.first {
      existing.update(from: user)
    } else {
      let newUser = CachedUser(context: context)
      newUser.update(from: user)
    }
  }
}
