//
//  PostViewModelTests 2.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import XCTest
import Combine
@testable import CombineExample

class PostViewModelTests: XCTestCase {
  var viewModel: PostViewModel!
  var mockNetworkService: MockNetworkService!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    mockNetworkService = MockNetworkService()
    viewModel = PostViewModel(networkService: mockNetworkService)
    cancellables = []
  }
  
  override func tearDown() {
    viewModel = nil
    mockNetworkService = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testFetchPostsSuccess() {
    let mockPosts = [
      Post(userId: 1, id: 1, title: "Test Post 1", body: "Test body 1"),
      Post(userId: 2, id: 2, title: "Test Post 2", body: "Test body 2")
    ]
    mockNetworkService.result = .success(mockPosts)
    
    // When
    viewModel.fetchPosts()
    
    // Then
    viewModel.$posts
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { posts in
        XCTAssertEqual(posts, mockPosts)
        XCTAssertFalse(self.viewModel.isLoading)
        XCTAssertNil(self.viewModel.errorMessage)
      }
      .store(in: &cancellables)
  }
  
  func testFetchPostsFailure() {
    let mockError = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    mockNetworkService.result = .failure(mockError)
    
    // When
    viewModel.fetchPosts()
    
    // Then
    viewModel.$errorMessage
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { errorMessage in
        XCTAssertEqual(errorMessage, mockError.localizedDescription)
        XCTAssertFalse(self.viewModel.isLoading)
        XCTAssertTrue(self.viewModel.posts.isEmpty)
      }
      .store(in: &cancellables)
  }
}
