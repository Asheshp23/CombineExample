//
//  PostListView.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import SwiftUI

struct PostListView: View {
  @StateObject private var viewModel: PostViewModel
  
  init(viewModel: PostViewModel = PostViewModel()) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        List(viewModel.posts) { post in
          VStack(alignment: .leading) {
            Text(post.title)
              .font(.headline)
            Text(post.body)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
        }
        .listStyle(PlainListStyle())
        .refreshable {
          viewModel.fetchPosts()
        }
        .accessibility(identifier: "postList")
        
        if viewModel.isLoading {
          ProgressView()
            .accessibility(identifier: "loadingIndicator")
        }
      }
      .navigationTitle("Posts")
      .alert(item: Binding<AlertItem?>(
        get: { viewModel.errorMessage.map { AlertItem(message: $0) } },
        set: { _ in viewModel.errorMessage = nil }
      )) { alertItem in
        Alert(title: Text("Error"), message: Text(alertItem.message))
      }
    }
    .onAppear {
      viewModel.fetchPosts()
    }
  }
}

#Preview {
  PostListView(viewModel: PostViewModel(networkService: PreviewMockNetworkService()))
}
