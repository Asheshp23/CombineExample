//
//  NetworkServiceTests.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import XCTest
import Combine
@testable import CombineExample

class NetworkServiceTests: XCTestCase {
  var networkService: NetworkService!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    networkService = NetworkService()
    cancellables = []
  }
  
  override func tearDown() {
    networkService = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testFetchPostsSuccess() {
    // Given
    let expectation = self.expectation(description: "Fetch posts")
    // When
    networkService.getData()
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          XCTFail("Expected successful fetch, but got error: \(error)")
        }
      } receiveValue: { posts in
        // Then
        XCTAssertFalse(posts.isEmpty)
        XCTAssertGreaterThan(posts.count, 0)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 5)
  }
}
