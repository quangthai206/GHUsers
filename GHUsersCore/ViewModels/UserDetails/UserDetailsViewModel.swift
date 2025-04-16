//
//  UserDetailsViewModel.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation
import Combine

public final class UserDetailsViewModel: UserDetailsViewModelProtocol {
  private let userService: UserServiceProtocol
  
  private let reloadSubject = PassthroughSubject<Void, Never>()
  private let errorSubject = CurrentValueSubject<String?, Never>(nil)
  
  private var user: GitHubUser
  
  public init(
    user: GitHubUser,
    userService: UserServiceProtocol
  ) {
    self.user = user
    self.userService = userService
  }
}

// MARK: - Methods

extension UserDetailsViewModel {
  public func fetchUserDetails() {
    Task {
      do {
        user = try await userService.fetchUserDetails(with: user.login)
        await MainActor.run {
          self.reloadSubject.send()
        }
      } catch {
        await MainActor.run {
          self.errorSubject.send("Failed to load user details")
        }
      }
    }
  }
}

// MARK: - Getters

extension UserDetailsViewModel {
  public var userLogin: String { user.login }
  
  public var blogURL: URL? {
    guard let blogLink = user.blogLink else {
      return nil
    }
    
    return URL(string: blogLink)
  }
  
  public var followersCountText: String { "\(user.followers ?? 0)" }
  public var followingCountText: String { "\(user.following ?? 0)" }
  
  public var isBlogInfoHidden: Bool { blogURL == nil }
  
  public var reloadPublisher: AnyPublisher<Void, Never> {
    reloadSubject.eraseToAnyPublisher()
  }
  public var errorPublisher: AnyPublisher<String?, Never> {
    errorSubject.eraseToAnyPublisher()
  }
  
  public var cardViewVM: UserCardViewModelProtocol {
    UserCardViewModel(user: user)
  }
}
