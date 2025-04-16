//
//  UserDetailsViewModelProtocol.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation
import Combine

public protocol UserDetailsViewModelProtocol {
  var userLogin: String { get }
  var blogURL: URL? { get }
  var followersCountText: String { get }
  var followingCountText: String { get }
  
  var isBlogInfoHidden: Bool { get }
  
  var reloadPublisher: AnyPublisher<Void, Never> { get }
  var errorPublisher: AnyPublisher<String?, Never> { get }
  
  var cardViewVM: UserCardViewModelProtocol { get }
  
  func fetchUserDetails()
}
