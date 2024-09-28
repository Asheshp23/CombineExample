//
//  PreviewMockNetworkService.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import Combine

let samplePosts = [
  Post(userId: 1, id: 1, title: "First Post", body: "This is the body of the first post"),
  Post(userId: 1, id: 2, title: "Second Post", body: "This is the body of the second post"),
  Post(userId: 2, id: 3, title: "Third Post", body: "This is the body of the third post")
]

class PreviewMockNetworkService: NetworkServiceProtocol {
  func getData() -> AnyPublisher<[Post], Error> {
    return Just(samplePosts)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
