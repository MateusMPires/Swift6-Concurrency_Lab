//
//  Models.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 16/03/26.
//

import Foundation

// Usei "nonisolated" porque no Swift 6 tudo nasce "amarrado" à Main Thread, e para tirar o warning precisei marcar aa conformaidade de Codable dessa struct como nonisolated
struct User: nonisolated Codable, Identifiable, Sendable {
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
