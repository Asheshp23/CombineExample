//
//  PostViewModel.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import Combine

class PostViewModel: ObservableObject {
  @Published var posts: [Post] = []
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  private var cancellables = Set<AnyCancellable>()
  private let networkService: NetworkServiceProtocol
  
  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }
  
  func fetchPosts() {
    isLoading = true
    errorMessage = nil
    
    networkService.getData()
      .sink { [weak self] completion in
        self?.isLoading = false
        if case .failure(let error) = completion {
          self?.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] posts in
        self?.posts = posts
      }
      .store(in: &cancellables)
  }
}
