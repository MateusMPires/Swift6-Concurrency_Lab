//
//  DownloadSheetView.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 16/03/26.
//

import SwiftUI

struct DownloadSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var viewModel: ContentViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // 1. O Cabeçalho de Status
                VStack(spacing: 8) {
                    Image(systemName: viewModel.isDownloading ? "network" : "externaldrive.fill.badge.checkmark")
                        .font(.system(size: 50))
                        .foregroundStyle(viewModel.isDownloading ? .blue : .green)
                        .symbolEffect(.pulse, isActive: viewModel.isDownloading)
                    
                    Text(viewModel.statusMessage)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(height: 120)
                
                if !viewModel.isDownloading && !viewModel.isFinished {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Como a Sincronização Funciona:")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.secondary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            InfoRow(icon: "magnifyingglass", text: "Verifica se os dados já existem no Cache local.")
                            InfoRow(icon: "network", text: "Se não existirem, baixa das API's usando TaskGroup.")
                            InfoRow(icon: "tray.and.arrow.down.fill", text: "Salva no Cache para acesso instantâneo no futuro.")
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    .transition(.opacity)
                }
                
                // 2. Os Botões de Ação
                if viewModel.isDownloading {
                    ProgressView()
                        .controlSize(.large)
                        .padding(.bottom, 10)
                    
                    Button(role: .destructive) {
                        viewModel.cancelPipeline()
                    } label: {
                        Label("Cancelar Download", systemImage: "xmark.octagon.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                    
                } else if !viewModel.isFinished {
                    
                    Button {
                        viewModel.startPipeline()
                    } label: {
                        Label("Iniciar Pipeline de Dados", systemImage: "arrow.down.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue, in: RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                }
                
                // 3. A LISTA ANIMADA DE DADOS E O BOTÃO DE REFRESH
                if viewModel.isFinished {
                    
                    Button {
                        viewModel.startPipeline(forceAPI: true)
                    } label: {
                        Label("Forçar Chamada da API", systemImage: "arrow.triangle.2.circlepath")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.orange.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.downloadedUsers.isEmpty {
                        List(viewModel.downloadedUsers) { user in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(user.id). \(user.name)") 
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .listStyle(.plain)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Sincronização")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
            .onDisappear {
                if viewModel.isDownloading {
                    // Se o usuário fechar no meio do download, cancela a rede
                    viewModel.cancelPipeline()
                }
                
                // Limpa a tela para a próxima vez, preservando o cache!
                viewModel.resetVisualState()
            }
        }
    }
}

// Subcomponente criado para deixar o código da View principal mais limpo
struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(width: 30)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
            
            Spacer()
        }
    }
}
