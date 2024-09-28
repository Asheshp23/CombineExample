//
//  PreviewMockNetworkServiceTests.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import XCTest
import Combine
@testable import CombineExample

class PreviewMockNetworkServiceTests: XCTestCase {
  
  var mockService: PreviewMockNetworkService!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    mockService = PreviewMockNetworkService()
    cancellables = []
  }
  
  override func tearDown() {
    mockService = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testGetDataReturnsSamplePosts() {
    // Given
    let expectation = self.expectation(description: "Fetch sample posts")
    var receivedPosts: [Post] = []
    
    // When
    mockService.getData()
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            XCTFail("Expected successful completion, but got error: \(error)")
          }
          expectation.fulfill()
        },
        receiveValue: { posts in
          receivedPosts = posts
        }
      )
      .store(in: &cancellables)
    
    // Then
    waitForExpectations(timeout: 1)
    XCTAssertEqual(receivedPosts, samplePosts, "Received posts should match sample posts")
  }
  
  func testGetDataReturnsCorrectNumberOfPosts() {
    // Given
    let expectation = self.expectation(description: "Fetch sample posts")
    var receivedPostsCount = 0
    
    // When
    mockService.getData()
      .sink(
        receiveCompletion: { _ in expectation.fulfill() },
        receiveValue: { posts in
          receivedPostsCount = posts.count
        }
      )
      .store(in: &cancellables)
    
    // Then
    waitForExpectations(timeout: 1)
    XCTAssertEqual(receivedPostsCount, 3, "Should receive 3 sample posts")
  }
  
  func testGetDataReturnsPostsWithCorrectContent() {
    // Given
    let expectation = self.expectation(description: "Fetch sample posts")
    var receivedPosts: [Post] = []
    
    // When
    mockService.getData()
      .sink(
        receiveCompletion: { _ in expectation.fulfill() },
        receiveValue: { posts in
          receivedPosts = posts
        }
      )
      .store(in: &cancellables)
    
    // Then
    waitForExpectations(timeout: 1)
    XCTAssertEqual(receivedPosts[0].title, "First Post")
    XCTAssertEqual(receivedPosts[1].title, "Second Post")
    XCTAssertEqual(receivedPosts[2].title, "Third Post")
    XCTAssertEqual(receivedPosts[0].userId, 1)
    XCTAssertEqual(receivedPosts[2].userId, 2)
  }
  
  func testGetDataNeverFails() {
    // Given
    let expectation = self.expectation(description: "Fetch sample posts")
    var didComplete = false
    var didFail = false
    
    // When
    mockService.getData()
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            didComplete = true
          case .failure:
            didFail = true
          }
          expectation.fulfill()
        },
        receiveValue: { _ in }
      )
      .store(in: &cancellables)
    
    // Then
    waitForExpectations(timeout: 1)
    XCTAssertTrue(didComplete, "The publisher should complete successfully")
    XCTAssertFalse(didFail, "The publisher should never fail")
  }
  
  func testConformanceToNetworkServiceProtocol() {
    XCTAssertTrue(mockService is NetworkServiceProtocol, "PreviewMockNetworkService should conform to NetworkServiceProtocol")
  }
}
