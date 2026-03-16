//
//  ContentView.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 13/03/26.
//

import SwiftUI

// MARK: - Tela Principal
struct ContentView: View {

    @State private var isShowingDownloadSheet = false
    
    @State private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image(systemName: "globe")
                .foregroundStyle(.tint)
            
            Text("Hello, Concurrency!")
                .font(.body)
            
            Spacer()
        }
        .safeAreaInset(edge: .bottom, content: {
            Button {
                isShowingDownloadSheet = true
            } label: {
                Text("Começar")
                    .font(.headline)
                    .buttonStyle(.glassProminent)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
            }
            .padding()
        })
        .sheet(isPresented: $isShowingDownloadSheet) {
            DownloadSheetView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
