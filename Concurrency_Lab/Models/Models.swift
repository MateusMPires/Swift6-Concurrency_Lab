//
//  User.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 16/03/26.
//

import Foundation

struct User: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    let email: String
}

struct Post: Codable, Identifiable, Sendable {
    let id: Int
    let title: String
}

struct Comment: Codable, Identifiable, Sendable {
    let id: Int
    let body: String
}
