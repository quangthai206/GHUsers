//
//  UserListViewModel.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation
import Combine

public final class UserListViewModel: UserListViewModelProtocol {
  private let reloadSubject = PassthroughSubject<Void, Never>()
  
  private var users: [GitHubUser] = []
  
  private var cancellables = Set<AnyCancellable>()
  
  public init() {
    
  }
}

// MARK: - Methods

extension UserListViewModel {
  public func fetchUsers() {
    // TODO: Dummy data
    users = [
      GitHubUser(
        login: "jvantuyl",
        name: nil,
        location: nil,
        avatarURL: URL(string: "https://avatars.githubusercontent.com/u/101?v=4")!,
        htmlURL: URL(string: "https://github.com/jvantuyl")!,
        blogURL: nil,
        followers: 100,
        following: 5
      ),
      GitHubUser(
        login: "BrianTheCoder",
        name: nil,
        location: nil,
        avatarURL: URL(string: "https://avatars.githubusercontent.com/u/102?v=4")!,
        htmlURL: URL(string: "https://github.com/BrianTheCoder")!,
        blogURL: URL(string: "http://joshowens.dev/")!,
        followers: 1,
        following: 12
      ),
      GitHubUser(
        login: "freeformz",
        name: "Edward Muller",
        location: "PDX Area, OR",
        avatarURL: URL(string: "https://avatars.githubusercontent.com/u/103?v=4")!,
        htmlURL: URL(string: "https://github.com/freeformz")!,
        blogURL: nil,
        followers: 30,
        following: 40
      )
    ]
  }
  
  public func itemCellVM(at index: Int) -> UserCardViewModelProtocol {
    UserCardViewModel(user: users[index])
  }
  
  public func user(at index: Int) -> GitHubUser {
    users[index]
  }
}

// MARK: - Getters

extension UserListViewModel {
  public var numberOfUsers: Int { users.count }
  public var reloadPublisher: AnyPublisher<Void, Never> {
    reloadSubject.eraseToAnyPublisher()
  }
}
