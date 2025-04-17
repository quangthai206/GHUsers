//
//  UserListViewModelTests.swift
//  GHUsersCoreTests
//
//  Created by Quang Thai on 17/4/25.
//

import XCTest
import Combine
import CoreData
@testable import GHUsersCore

final class UserListViewModelTests: XCTestCase {
  private var mockApiClient: MockGitHubAPIClient!
  private var coreDataStack: CoreDataStack!
  private var coreDataClient: CoreDataClient!
  private var viewModel: UserListViewModel!
  private var cancellables: Set<AnyCancellable> = []
  
  override func setUp() {
    super.setUp()
    mockApiClient = MockGitHubAPIClient()
    coreDataStack = CoreDataStack.inMemory()
    coreDataClient = CoreDataClient(coreDataStack: coreDataStack)
    let service = UserService(apiClient: mockApiClient, coreDataClient: coreDataClient)
    viewModel = UserListViewModel(userService: service, config: MockAppConfig())
  }
  
  override func tearDown() {
    mockApiClient = nil
    coreDataStack = nil
    coreDataClient = nil
    viewModel = nil
    cancellables.removeAll()
    super.tearDown()
  }
  
  // MARK: - Fetching Users
  
  func testFetchUsersIfNeeded_FirstCall_FetchesUsersAndSaves() async throws {
    // Arrange
    let expectation = XCTestExpectation(description: "Reload publisher called")
    let mockUsers = [
      GitHubUser.mock(id: 1, login: "user1"),
      GitHubUser.mock(id: 2, login: "user2")
    ]
    mockApiClient.usersToReturn = mockUsers
    
    viewModel.reloadPublisher
      .sink { expectation.fulfill() }
      .store(in: &cancellables)
    
    // Act
    viewModel.fetchUsersIfNeeded()
    
    // Assert
    await fulfillment(of: [expectation], timeout: 0.5)
    XCTAssertEqual(viewModel.numberOfUsers, mockUsers.count, "Number of users should match fetched count")
    
    // Verify data is saved to Core Data
    let context = coreDataStack.context
    let fetchRequest: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
    let savedUsers = try context.fetch(fetchRequest)
    XCTAssertEqual(savedUsers.count, mockUsers.count, "Saved users count should match")
  }
  
  func testFetchUsersIfNeeded_FailedFetch_PublishesError() async {
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
    viewModel.fetchUsersIfNeeded()
    
    // Assert
    await fulfillment(of: [expectation], timeout: 0.5)
  }
  
  func testFetchUsersIfNeeded_SubsequentCall_FetchesNextPage() async throws {
    // Arrange
    let initialUsers = [GitHubUser.mock(id: 1, login: "user1")]
    mockApiClient.usersToReturn = initialUsers
    
    let reloadExpectation1 = XCTestExpectation(description: "Reload publisher called 1")
    viewModel.reloadPublisher
      .sink { reloadExpectation1.fulfill() }
      .store(in: &cancellables)
    
    viewModel.fetchUsersIfNeeded() // Initial fetch
    await fulfillment(of: [reloadExpectation1], timeout: 0.5)
    
    let nextUsers = [GitHubUser.mock(id: 21, login: "user21")]
    mockApiClient.usersToReturn = nextUsers
    
    let reloadExpectation2 = XCTestExpectation(description: "Reload publisher called 2")
    viewModel.reloadPublisher
      .sink { reloadExpectation2.fulfill() }
      .store(in: &cancellables)
    
    // Act
    viewModel.fetchUsersIfNeeded() // Second fetch
    await fulfillment(of: [reloadExpectation2], timeout: 0.5)
    
    // Assert
    XCTAssertEqual(viewModel.numberOfUsers, initialUsers.count + nextUsers.count, "Should fetch next page")
    
    // Verify data is saved to Core Data
    let context = coreDataStack.context
    let fetchRequest: NSFetchRequest<CachedUser> = CachedUser.fetchRequest()
    let savedUsers = try context.fetch(fetchRequest)
    XCTAssertEqual(savedUsers.count, initialUsers.count + nextUsers.count, "Saved users should include both sets")
  }
  
  func testUser_ReturnsCorrectUserAtIndex() async throws {
    // Arrange
    let mockUsers = [GitHubUser.mock(id: 1, login: "user1"), GitHubUser.mock(id: 2, login: "user2")]
    mockApiClient.usersToReturn = mockUsers
    
    let expectation = XCTestExpectation(description: "Reload should be called")
    
    viewModel.reloadPublisher
      .sink { expectation.fulfill() }
      .store(in: &cancellables)
    
    viewModel.fetchUsersIfNeeded()
    
    await fulfillment(of: [expectation], timeout: 0.5)
    
    // Act
    let user = viewModel.user(at: 1)
    
    // Assert
    XCTAssertEqual(user?.login, "user2", "Should return the user at the correct index")
  }
  
  func testUser_ReturnsNilForInvalidIndex() {
    // Arrange (No fetch, empty data)
    
    // Act
    let user = viewModel.user(at: 0)
    
    // Assert
    XCTAssertNil(user, "Should return nil for an invalid index")
  }
  
  // MARK: - Item Cell View Model
  
  func testItemCellVM_ReturnsViewModelForValidIndex() async throws {
    // Arrange
    let mockUsers = [GitHubUser.mock(id: 1, login: "user1")]
    mockApiClient.usersToReturn = mockUsers
    
    let expectation = XCTestExpectation(description: "Reload should be called")
    
    viewModel.reloadPublisher
      .sink { expectation.fulfill() }
      .store(in: &cancellables)
    
    viewModel.fetchUsersIfNeeded()
    
    await fulfillment(of: [expectation], timeout: 0.5)
    
    // Act
    let cellViewModel = viewModel.itemCellVM(at: 0)
    
    // Assert
    XCTAssertNotNil(cellViewModel, "Should return a cell view model")
  }
  
  func testItemCellVM_ReturnsNilForInvalidIndex() {
    // Arrange (No fetch)
    
    // Act
    let cellViewModel = viewModel.itemCellVM(at: 0)
    
    // Assert
    XCTAssertNil(cellViewModel, "Should return nil for an invalid index")
  }
  
  // MARK: - Number of Users
  
  func testNumberOfUsers_ReturnsCorrectCount() async throws {
    // Arrange
    let mockUsers = [GitHubUser.mock(id: 1), GitHubUser.mock(id: 2), GitHubUser.mock(id: 3)]
    mockApiClient.usersToReturn = mockUsers
    
    let expectation = XCTestExpectation(description: "Reload should be called")
    
    viewModel.reloadPublisher
      .sink { expectation.fulfill() }
      .store(in: &cancellables)
    
    viewModel.fetchUsersIfNeeded()
    
    await fulfillment(of: [expectation], timeout: 0.5)
    
    // Act
    let count = viewModel.numberOfUsers
    
    // Assert
    XCTAssertEqual(count, mockUsers.count, "Should return the correct number of users")
  }
  
  func testNumberOfUsers_ReturnsZeroInitially() {
    // Arrange (No fetch)
    
    // Act
    let count = viewModel.numberOfUsers
    
    // Assert
    XCTAssertEqual(count, 0, "Should return zero initially")
  }
}
