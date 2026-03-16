//
//  ContentViewModel.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 16/03/26.
//

import SwiftUI

@Observable
@MainActor
class ContentViewModel {
    var statusMessage = "Pronto para iniciar"
    var isDownloading = false
    var isFinished = false
    
    var downloadedUsers: [User] = []
    var hasOnCache: Bool = false
    // Se eles fossem injetados no init, poderiam ser instâncias globais do app (Singleton ou Environment)
    // Mas para o nosso laboratório, instanciá-los aqui funciona perfeitamente.
    let userCache = DataStore<User>()
    let postCache = DataStore<Post>()
    
    private let fetcher = DataFetcher()
    private var downloadTask: Task<Void, Never>?
    
    func startPipeline(forceAPI: Bool = false) {
        isDownloading = true
        isFinished = false
        downloadedUsers = []
        
        downloadTask = Task {
            do {

                if forceAPI {
                    await userCache.clear()
                    await postCache.clear()
                }
                
                // 1. LÓGICA CACHE-FIRST PARA USERS
                let cachedUsers = await userCache.items
                let hasOnCache = !cachedUsers.isEmpty
                
                let userIDs = Array(1...5)
                
                if cachedUsers.isEmpty {
                    self.statusMessage = "1/2: Baixando Usuários da API..."
                    let fetchedUsers = try await fetcher.fetchUsers(ids: userIDs)
                    await userCache.save(fetchedUsers)
                } else {
                    self.statusMessage = "1/2: Carregando Usuários do Cache..."
                    print("Carregando cache")
                    try await Task.sleep(for: .milliseconds(1000))
                }
                
                try Task.checkCancellation()
                
                // 2. LÓGICA CACHE-FIRST PARA POSTS
                let cachedPosts = await postCache.items
                if cachedPosts.isEmpty {
                    self.statusMessage = "2/2: Baixando Posts da API..."
                    let fetchedPosts = try await fetcher.fetchPosts(for: userIDs)
                    await postCache.save(fetchedPosts)
                } else {
                    self.statusMessage = "2/2: Carregando Posts do Cache..."
                    try await Task.sleep(for: .milliseconds(1000))
                }
                
                self.statusMessage = hasOnCache ? "Sucesso! Dados carregados do Cache." : "Sucesso! Dados buscados da API."
                
                // Finalizamos lendo a fonte da verdade 
                let finalUsers = await userCache.items
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    self.downloadedUsers = finalUsers
                    self.isFinished = true
                }
                
            } catch is CancellationError {
                self.statusMessage = "⚠️ Pipeline cancelado."
            } catch let error as URLError where error.code == .cancelled {
                self.statusMessage = "⚠️ Pipeline cancelado."
            } catch {
                self.statusMessage = "❌ Erro na rede: \(error.localizedDescription)"
            }
            
            self.isDownloading = false
        }
    }
    
    func cancelPipeline() {
        downloadTask?.cancel()
    }
    
    // Limpa o estado visual para a próxima vez que o Sheet abrir,
    // MAS mantém os dados salvos nos atores de Cache.
    func resetVisualState() {
        self.downloadedUsers.removeAll()
        self.isFinished = false
        self.statusMessage = "Pronto para iniciar"
    }
}
