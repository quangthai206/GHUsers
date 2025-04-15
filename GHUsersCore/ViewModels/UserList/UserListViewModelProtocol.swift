//
//  UserListViewModelProtocol.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation
import Combine

public protocol UserListViewModelProtocol {
  var reloadPublisher: AnyPublisher<Void, Never> { get }
  var numberOfUsers: Int { get }
  
  func itemCellVM(at index: Int) -> UserCardViewModelProtocol
  func user(at index: Int) -> GitHubUser
  func fetchUsers()
}
