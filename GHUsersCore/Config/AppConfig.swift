//
//  AppConfig.swift
//  GHUsers
//
//  Created by Quang Thai on 16/4/25.
//

import Foundation

public protocol AppConfigProtocol {
  // MARK: Backend

  var baseUrl: String { get }

  // MARK: Defaults

  var defaultPageSize: Int { get }
}

// MARK: - Default values

extension AppConfigProtocol {
  public var defaultPageSize: Int { 20 }
}

// MARK: - Concrete Type

public struct AppConfig: AppConfigProtocol {
  public var baseUrl: String { "https://api.github.com" }
  
  public init() {}
}
