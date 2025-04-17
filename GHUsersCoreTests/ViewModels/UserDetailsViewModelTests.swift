//
//  UserDetailsViewModelTests.swift
//  GHUsersCoreTests
//
//  Created by Quang Thai on 17/4/25.
//

import XCTest
import Combine
@testable import GHUsersCore

final class UserDetailsViewModelTests: XCTestCase {
  private var mockApiClient: MockGitHubAPIClient!
  private var coreDataStack: CoreDataStack!
  private var coreDataClient: CoreDataClient!
  private var viewModel: UserDetailsViewModel!
  private var user: CachedUser!
  private var cancellables: Set<AnyCancellable> = []
  
  override func setUp() {
    super.setUp()
    
    coreDataStack = CoreDataStack.inMemory()
    let context = coreDataStack.context
    
    user = CachedUser(context: context)
    user.id = 1
    user.login = "mockuser"
    user.avatarUrl = "https://example.com/avatar.png"
    user.htmlUrl = "https://github.com/mockuser"
    user.followers = 0
    user.following = 0
    
    mockApiClient = MockGitHubAPIClient()
    coreDataClient = CoreDataClient(coreDataStack: coreDataStack)
    let service = UserService(apiClient: mockApiClient, coreDataClient: coreDataClient)
    
    viewModel = UserDetailsViewModel(user: user, userService: service)
  }
  
  override func tearDown() {
    mockApiClient = nil
    coreDataStack = nil
    coreDataClient = nil
    viewModel = nil
    cancellables.removeAll()
    super.tearDown()
  }
  
  // MARK: - Fetching User Details
  
  func testFetchUserDetails_SuccessfulFetch_UpdatesUserAndPublishesReload() async throws {
    // Arrange
    let expectation = XCTestExpectation(description: "Reload publisher called")
    let mockDetailedUser = GitHubUser.mock(name: "Mock User", location: "Mock Location", blogLink: "https://mock.blog", followers: 100, following: 50)
    mockApiClient.userDetailToReturn = mockDetailedUser
    
    viewModel.reloadPublisher
      .sink { expectation.fulfill() }
      .store(in: &cancellables)
    
    // Act
    viewModel.fetchUserDetails()
    
    // Assert
    await fulfillment(of: [expectation], timeout: 0.5)
    XCTAssertEqual(viewModel.userLogin, "mockuser", "User login should remain the same")
    XCTAssertEqual(viewModel.blogURL?.absoluteString, "https://mock.blog", "Blog URL should be updated")
    XCTAssertEqual(viewModel.followersCountText, "100", "Followers count text should be correct")
    XCTAssertEqual(viewModel.followingCountText, "50", "Following count text should be correct")
    XCTAssertFalse(viewModel.isBlogInfoHidden, "Blog info should not be hidden")
    
    // Verify Core Data update
    XCTAssertEqual(user.name, "Mock User", "CachedUser name should be updated")
    XCTAssertEqual(user.location, "Mock Location", "CachedUser location should be updated")
    XCTAssertEqual(user.blogLink, "https://mock.blog", "CachedUser blogLink should be updated")
    XCTAssertEqual(Int(user.followers), 100, "CachedUser followers should be updated")
    XCTAssertEqual(Int(user.following), 50, "CachedUser following should be updated")
  }
  
  func testFetchUserDetails_FailedFetch_PublishesError() async {
    // Arrange
    let expectation = XCTestExpectation(description: "Error publisher called")
    mockApiClient.shouldFail = true
    
    viewModel.errorPublisher
      .dropFirst()
      .compactMap { $0 }
      .sink { error in
        XCTAssertNotNil(error, "Error message should be published")
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // Act
    viewModel.fetchUserDetails()
    
    // Assert
    await fulfillment(of: [expectation], timeout: 0.5)
  }
  
  // MARK: - Initial State
  
  func testInitialState_SetsUserPropertiesCorrectly() {
    // Arrange (using setUp)
    
    // Act & Assert
    XCTAssertEqual(viewModel.userLogin, "mockuser", "Initial userLogin should be correct")
    XCTAssertNil(viewModel.blogURL, "Initial blogURL should be nil")
    XCTAssertEqual(viewModel.followersCountText, "0", "Initial followersCountText should be 0")
    XCTAssertEqual(viewModel.followingCountText, "0", "Initial followingCountText should be 0")
    XCTAssertTrue(viewModel.isBlogInfoHidden, "Initial isBlogInfoHidden should be true")
  }
  
  // MARK: - Getters
  
  func testGetters_ReturnCorrectValuesAfterUpdate() async throws {
    // Arrange
    let mockDetailedUser = GitHubUser.mock(name: "Updated Name", location: "Updated Location", blogLink: "https://updated.blog", followers: 200, following: 100)
    mockApiClient.userDetailToReturn = mockDetailedUser
    
    let expectation = XCTestExpectation(description: "Reload should be called")
    
    viewModel.reloadPublisher
      .sink { expectation.fulfill() }
      .store(in: &cancellables)
    
    viewModel.fetchUserDetails()
    
    await fulfillment(of: [expectation], timeout: 0.5)
    
    // Act & Assert
    XCTAssertEqual(viewModel.userLogin, "mockuser", "userLogin should remain the same")
    XCTAssertEqual(viewModel.blogURL?.absoluteString, "https://updated.blog", "blogURL should be updated")
    XCTAssertEqual(viewModel.followersCountText, "200", "followersCountText should be updated")
    XCTAssertEqual(viewModel.followingCountText, "100", "followingCountText should be updated")
    XCTAssertFalse(viewModel.isBlogInfoHidden, "isBlogInfoHidden should be updated")
  }
  
  func testCardViewModel_ReturnsCorrectViewModel() {
    // Arrange (using setUp)
    
    // Act
    let cardViewModel = viewModel.cardViewVM
    
    // Assert
    XCTAssertEqual(cardViewModel.nameText, "mockuser", "Card view model should have the correct user")
  }
}
