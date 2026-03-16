//
//  DataFetcher.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 16/03/26.
//

import Foundation

struct DataFetcher {
    
    // 1. Baixa 10 usuários simultaneamente (IDs de 1 a 10)
    func fetchUsers(ids: [Int]) async throws -> [User] {
        try await withThrowingTaskGroup(of: User.self) { group in
            for id in ids {
                group.addTask {
                    return try await fetchSingle(url: "https://jsonplaceholder.typicode.com/users/\(id)")
                }
            }
            
            var users: [User] = []
            for try await user in group {
                users.append(user)
            }
            
            users.sort { $0.id < $1.id }
            
            return users
        }
    }
    
    // 2. Recebe a lista de usuários e baixa os posts DELES simultaneamente
    func fetchPosts(for userIds: [Int]) async throws -> [Post] {
        try await withThrowingTaskGroup(of: [Post].self) { group in
            for userId in userIds {
                group.addTask {
                    return try await fetchSingle(url: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
                }
            }
            
            var allPosts: [Post] = []
            for try await userPosts in group {
                allPosts.append(contentsOf: userPosts)
            }
            return allPosts
        }
    }
    
    // Função genérica de rede com cancelamento cooperativo
    private func fetchSingle<T: Codable>(url: String) async throws -> T {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        try Task.checkCancellation()
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
