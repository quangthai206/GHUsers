//
//  UserCardViewModel.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation

public final class UserCardViewModel: UserCardViewModelProtocol {
  private let user: CachedUser
  
  init(user: CachedUser) {
    self.user = user
  }
}

// MARK: - Getters

extension UserCardViewModel {
  public var avatarURL: URL? { URL(string: user.avatarUrl) }
  public var nameText: String { user.name ?? user.login }
  public var linkURL: URL? { URL(string: user.htmlUrl) }
  public var locationText: String? { user.location }
  
  public var isLinkURLHidden: Bool { linkURL == nil }
  public var isLocationHidden: Bool { locationText == nil }
}
