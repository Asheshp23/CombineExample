//
//  MockNetworkServiceTests.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import XCTest
import Combine
@testable import CombineExample

class MockNetworkServiceTests: XCTestCase {
  
  var mockService: MockNetworkService!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    mockService = MockNetworkService()
    cancellables = []
  }
  
  override func tearDown() {
    mockService = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testGetDataFailureCase() {
    // Given
    let expectedError = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    mockService.result = .failure(expectedError)
    
    let expectation = self.expectation(description: "Fetch posts error")
    
    // When
    var receivedError: Error?
    mockService.getData()
      .sink { completion in
        switch completion {
        case .finished:
          XCTFail("Expected failure, but got successful completion")
        case .failure(let error):
          receivedError = error
          expectation.fulfill()
        }
      } receiveValue: { _ in
        XCTFail("Expected failure, but received posts")
      }
      .store(in: &cancellables)
    
    // Then
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(receivedError, "Should have received an error")
    XCTAssertEqual((receivedError as NSError?)?.domain, expectedError.domain)
    XCTAssertEqual((receivedError as NSError?)?.code, expectedError.code)
  }
  
  func testGetDataWithoutSettingResult() {
    // Given
    mockService.result = nil
    
    let expectation = self.expectation(description: "Should receive error")
    
    // When
    var receivedError: Error?
    mockService.getData()
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            receivedError = error
            expectation.fulfill()
          }
        },
        receiveValue: { _ in
          XCTFail("Should not receive any value")
        }
      )
      .store(in: &cancellables)
    
    // Then
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(receivedError, "Should have received an error")
    XCTAssertTrue(receivedError is MockNetworkServiceError, "Error should be of type MockNetworkServiceError")
    XCTAssertEqual(receivedError as? MockNetworkServiceError, .resultNotSet, "Error should be resultNotSet")
  }
}

// Helper to catch fatalError
extension XCTestCase {
  func XCTAssertThrowsError<T>(_ expression: @autoclosure () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line, _ errorHandler: (Error) -> Void = { _ in }) {
    do {
      _ = try expression()
      XCTFail("No error was thrown - \(message)", file: file, line: line)
    } catch {
      errorHandler(error)
    }
  }
}
