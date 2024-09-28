//
//  Post.swift
//  CombineExample
//
//  Created by Ashesh Patel on 2024-09-27.
//
import Foundation

struct Post: Codable, Identifiable, Equatable {
  let userId: Int
  let id: Int
  let title: String
  let body: String
}
