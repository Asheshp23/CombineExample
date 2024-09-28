//
//  MockNetworkService.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import Combine

enum MockNetworkServiceError: Error {
  case resultNotSet
}

class MockNetworkService: NetworkServiceProtocol {
  var result: Result<[Post], Error>?
  
  func getData() -> AnyPublisher<[Post], Error> {
    guard let result = result else {
      return Fail(error: MockNetworkServiceError.resultNotSet).eraseToAnyPublisher()
    }
    return result.publisher.eraseToAnyPublisher()
  }
}
