//
//  GHUsersUITests.swift
//  GHUsersUITests
//
//  Created by Quang Thai on 17/4/25.
//

import XCTest

final class GHUsersUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments = ["--uitesting"]
    app.launch()
  }
  
  override func tearDownWithError() throws {
    app = nil
  }
  
  func testUserListLoadingAndNavigation() throws {
    // Ensure the user list loads.
    let usersTable = app.tables["usersTableView"]
    XCTAssertTrue(usersTable.waitForExistence(timeout: 5))
    
    // Tap the first user cell.
    let firstCellNameLabel = usersTable.cells.element(boundBy: 0).staticTexts["userCardNameLabel"]
    firstCellNameLabel.tap()
    
    // Verify that the user details screen appears.
    let userDetailsCardView = app.otherElements["userDetailsCardView"]
    XCTAssertTrue(userDetailsCardView.waitForExistence(timeout: 5))
    
    // Go back to the user list.
    app.navigationBars.buttons.element(boundBy: 0).tap()
    XCTAssertTrue(usersTable.waitForExistence(timeout: 2))
  }
  
  func testUserDetailsInformation() throws {
    // Navigate to user details (assuming the first user is available)
    let usersTable = app.tables["usersTableView"]
    XCTAssertTrue(usersTable.waitForExistence(timeout: 5))
    usersTable.cells.element(boundBy: 0).staticTexts["userCardNameLabel"].tap()
    
    let userDetailsCardView = app.otherElements["userDetailsCardView"]
    XCTAssertTrue(userDetailsCardView.waitForExistence(timeout: 5))
    
    // Verify details are displayed
    let followersLabel = app.staticTexts["followersCountLabel"]
    XCTAssertTrue(followersLabel.exists)
    
    let followingLabel = app.staticTexts["followingCountLabel"]
    XCTAssertTrue(followingLabel.exists)
  }
}
