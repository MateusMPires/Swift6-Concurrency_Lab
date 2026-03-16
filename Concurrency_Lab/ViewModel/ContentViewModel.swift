//
//  ContentViewModel 2.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 16/03/26.
//


import SwiftUI
import Observation

@Observable
@MainActor
class ContentViewModel {
    var statusMessage = "Pronto para iniciar"
    var isDownloading = false
    
    // 3 Cofres independentes (Zero Actor Contention)
    let userCache = DataStore<User>()
    let postCache = DataStore<Post>()
    
    private let fetcher = DataFetcher()
    private var downloadTask: Task<Void, Never>?
    
    func startPipeline() {
        isDownloading = true
        
        downloadTask = Task {
            do {
                // ETAPA 1: Usuários
                self.statusMessage = "1/3: Baixando Usuários em lote..."
                let userIDs = Array(1...5) // Vamos baixar 5 usuários
                let users = try await fetcher.fetchUsers(ids: userIDs)
                await userCache.save(users)
                
                // O checkCancellation() aqui garante que não vamos para a etapa 2 
                // se o usuário já tiver cancelado durante a etapa 1.
                try Task.checkCancellation()
                
                // ETAPA 2: Posts
                self.statusMessage = "2/3: Baixando Posts dos usuários..."
                let posts = try await fetcher.fetchPosts(for: userIDs)
                await postCache.save(posts)
                
                // (Etapa 3 seria idêntica para Comments)
                
                self.statusMessage = "Sucesso! Tudo salvo no Cache."
                
            } catch is CancellationError {
                self.statusMessage = "⚠️ Pipeline cancelado pelo usuário."
            } catch {
                self.statusMessage = "❌ Erro na rede: \(error.localizedDescription)"
            }
            
            self.isDownloading = false
        }
    }
    
    func cancelPipeline() {
        downloadTask?.cancel()
    }
}
