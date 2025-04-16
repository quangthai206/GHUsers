//
//  UserListViewModel.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation
import Combine
import CoreData

public final class UserListViewModel: NSObject, UserListViewModelProtocol {
  private let userService: UserServiceProtocol
  private let config: AppConfigProtocol
  
  @Published private(set) var errorMessage: String?
  
  private let reloadSubject = PassthroughSubject<Void, Never>()
  
  private lazy var fetchedResultsController: NSFetchedResultsController<CachedUser> = {
    let frc = userService.makeFetchedResultsController()
    frc.delegate = self
    try? frc.performFetch()
    return frc
  }()
  
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
  public func fetchUsersIfNeeded() {
    guard !isFetching else { return }
    
    isFetching = true
    
    Task {
      let lastUserId = fetchedResultsController.fetchedObjects?.last?.id
      do {
        try await userService.fetchRemoteUsers(
          since: Int(lastUserId ?? 0),
          perPage: config.defaultPageSize
        )
      } catch {
        errorMessage = "Failed to fetch users"
      }
      
      isFetching = false
    }
  }
  
  public func itemCellVM(at index: Int) -> UserCardViewModelProtocol? {
    guard let user = user(at: index) else {
      return nil
    }
    
    return UserCardViewModel(user: user)
  }
  
  public func user(at index: Int) -> CachedUser? {
    fetchedResultsController.fetchedObjects?[index]
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension UserListViewModel: NSFetchedResultsControllerDelegate {
  public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    reloadSubject.send()
  }
}

// MARK: - Getters

extension UserListViewModel {
  public var numberOfUsers: Int {
    fetchedResultsController.fetchedObjects?.count ?? 0
  }
  public var reloadPublisher: AnyPublisher<Void, Never> {
    reloadSubject.eraseToAnyPublisher()
  }
  public var errorPublisher: AnyPublisher<String?, Never> {
    $errorMessage.eraseToAnyPublisher()
  }
}
