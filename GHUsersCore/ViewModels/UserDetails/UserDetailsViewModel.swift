//
//  UserDetailsViewModel.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation

public final class UserDetailsViewModel: UserDetailsViewModelProtocol {
  private var user: GitHubUser
  
  public init(user: GitHubUser) {
    self.user = user
  }
}

// MARK: - Methods

extension UserDetailsViewModel {
  public func fetchUserDetails() {
    // TODO: Implement later
  }
}

// MARK: - Getters

extension UserDetailsViewModel {
  public var blogURL: URL? { user.blogURL }
  public var followersCountText: String { "\(user.followers ?? 0)" }
  public var followingCountText: String { "\(user.following ?? 0)" }
  
  public var isBlogInfoHidden: Bool { blogURL == nil }
  
  public var cardViewVM: UserCardViewModelProtocol {
    UserCardViewModel(user: user)
  }
}
