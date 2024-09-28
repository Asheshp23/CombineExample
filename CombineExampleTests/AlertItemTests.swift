//
//  AlertItemTests.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import XCTest
@testable import CombineExample

class AlertItemTests: XCTestCase {
  
  func testIdIsUUID() {
    // Given
    let alertItem = AlertItem(message: "Test message")
    
    // Then
    XCTAssertNotNil(UUID(uuidString: alertItem.id), "The id should be a valid UUID")
  }
  
  func testAlertItemCreation() {
    // Given
    let message = "Test alert message"
    
    // When
    let alertItem = AlertItem(message: message)
    
    // Then
    XCTAssertEqual(alertItem.message, message, "The message should match the input")
  }
  
  func testAlertItemIdUniqueness() {
    // Given
    let alertItem1 = AlertItem(message: "First message")
    let alertItem2 = AlertItem(message: "Second message")
    
    // Then
    XCTAssertNotEqual(alertItem1.id, alertItem2.id, "Each AlertItem should have a unique ID")
  }
  
  func testMessageProperty() {
    // Given
    let message = "Test alert message"
    let alertItem = AlertItem(message: message)
    
    // Then
    XCTAssertEqual(alertItem.message, message, "The message property should be accessible and match the input")
  }
}
