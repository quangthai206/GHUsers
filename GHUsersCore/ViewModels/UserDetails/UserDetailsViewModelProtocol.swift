//
//  UserDetailsViewModelProtocol.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation

public protocol UserDetailsViewModelProtocol {
  var blogURL: URL? { get }
  var followersCountText: String { get }
  var followingCountText: String { get }
  
  var isBlogInfoHidden: Bool { get }
  
  var cardViewVM: UserCardViewModelProtocol { get }
  
  func fetchUserDetails()
}
