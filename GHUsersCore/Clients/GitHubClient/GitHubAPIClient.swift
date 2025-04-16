//
//  GitHubAPIClient.swift
//  GHUsersCore
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation

public final class GitHubAPIClient: GitHubAPIClientProtocol {
  private let session: URLSession
  private let baseURL: URL
  
  public init(
    session: URLSession,
    baseURL: URL
  ) {
    self.session = session
    self.baseURL = baseURL
  }
}

// MARK: - Methods

extension GitHubAPIClient {
  public func fetchUsers(since userId: Int?, perPage: Int) async throws -> [GitHubUser] {
    guard var components = URLComponents(url: baseURL.appendingPathComponent("users"), resolvingAgainstBaseURL: false) else {
      throw URLError(.badURL)
    }
    
    var queryItems = [URLQueryItem(name: "per_page", value: "\(perPage)")]
    if let userId = userId {
      queryItems.append(URLQueryItem(name: "since", value: "\(userId)"))
    }
    components.queryItems = queryItems
    
    guard let url = components.url else {
      throw URLError(.badURL)
    }
    
    return try await fetch(from: url)
  }
  
  public func fetchUserDetails(with login: String) async throws -> GitHubUser {
    let url = baseURL.appendingPathComponent("users/\(login)")
    return try await fetch(from: url)
  }
}

// MARK: - Helpers

private extension GitHubAPIClient {
  func fetch<T: Decodable>(from url: URL) async throws -> T {
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
      throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode(T.self, from: data)
  }
}
