//
//  NeytworkService.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import Foundation
import Combine

protocol NetworkServiceProtocol {
  func getData() -> AnyPublisher<[Post], Error>
}

class NetworkService: NetworkServiceProtocol {
  private var cancellables = Set<AnyCancellable>()
  
  func getData() -> AnyPublisher<[Post], Error>  {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { result -> Data in
        guard let httpResponse = result.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        
        return result.data
      }
      .decode(type: [Post].self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main) // Ensures updates happen on the main thread
      .eraseToAnyPublisher()
  }
}
