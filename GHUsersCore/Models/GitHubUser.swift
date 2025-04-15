//
//  GitHubUser.swift
//  GHUsersCore
//
//  Created by Quang Thai on 15/4/25.
//

import Foundation

public struct GitHubUser: Decodable {
  public let login: String
  public let name: String?
  public let location: String?
  public let avatarURL: URL
  public let htmlURL: URL
  public let blogURL: URL?
  public let followers: Int?
  public let following: Int?
  
  enum CodingKeys: String, CodingKey {
    case login
    case name
    case location
    case avatarURL = "avatar_url"
    case htmlURL = "html_url"
    case blogURL = "blog"
    case followers
    case following
  }
}
