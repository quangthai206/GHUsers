//
//  UserListViewModel.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation
import Combine

public final class UserListViewModel: UserListViewModelProtocol {
  private let userService: UserServiceProtocol
  private let config: AppConfigProtocol
  
  private let reloadSubject = PassthroughSubject<Void, Never>()
  private let errorSubject = CurrentValueSubject<String?, Never>(nil)
  
  private var users: [GitHubUser] = []
  private var isFetching = false
  
  public init(
    userService: UserServiceProtocol,
    config: AppConfigProtocol
  ) {
    self.userService = userService
    self.config = config
  }
}

// MARK: - Methods

extension UserListViewModel {
  public func fetchUsers() {
    Task {
      if isFetching { return }
      isFetching = true
      
      do {
        let fetchedUsers = try await userService.fetchUsers(
          since: users.last?.id,
          perPage: config.defaultPageSize
        )
        
        await MainActor.run {
          if !fetchedUsers.isEmpty {
            self.users.append(contentsOf: fetchedUsers)
          }
          self.isFetching = false
          self.reloadSubject.send()
        }
        
      } catch {
        await MainActor.run {
          self.isFetching = false
          self.errorSubject.send("Failed to load users")
        }
      }
    }
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
  public var errorPublisher: AnyPublisher<String?, Never> {
    errorSubject.eraseToAnyPublisher()
  }
}
