//
//  PostListViewUITests.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import XCTest
@testable import CombineExample

class PostListViewUITests: XCTestCase {
  let app = XCUIApplication()
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launch()
  }
  
  func testPostListViewAppears() throws {
    // Check if the navigation title is correct
    XCTAssertTrue(app.navigationBars["Posts"].exists)
  }
}
