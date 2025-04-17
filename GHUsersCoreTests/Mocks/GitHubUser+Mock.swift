//
//  GitHubUser+Mock.swift
//  GHUsersCoreTests
//
//  Created by Quang Thai on 17/4/25.
//

import Foundation
@testable import GHUsersCore

extension GitHubUser {
  static func mock(
    id: Int = 1,
    login: String = "mockuser",
    name: String? = nil,
    location: String? = nil,
    avatarURL: URL = URL(string: "https://example.com/avatar.png")!,
    htmlURL: URL = URL(string: "https://github.com/mockuser")!,
    blogLink: String? = nil,
    followers: Int? = nil,
    following: Int? = nil
  ) -> GitHubUser {
    return GitHubUser(
      id: id,
      login: login,
      name: name,
      location: location,
      avatarURL: avatarURL,
      htmlURL: htmlURL,
      blogLink: blogLink,
      followers: followers,
      following: following
    )
  }
}
