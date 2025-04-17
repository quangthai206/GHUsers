//
//  MockAppConfig.swift
//  GHUsersCoreTests
//
//  Created by Quang Thai on 17/4/25.
//

@testable import GHUsersCore

final class MockAppConfig: AppConfigProtocol {
  var baseUrl: String = ""
  var defaultPageSize: Int = 20
}
