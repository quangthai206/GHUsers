//
//  UserCardViewModelProtocol.swift
//  GHUsers
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation

public protocol UserCardViewModelProtocol {
  var avatarURL: URL? { get }
  var nameText: String { get }
  var linkURL: URL? { get }
  var locationText: String? { get }
  
  var isLinkURLHidden: Bool { get }
  var isLocationHidden: Bool { get }
}
