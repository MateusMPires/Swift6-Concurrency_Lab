//
//  DataStore.swift
//  Concurrency_Lab
//
//  Created by Mateus Martins Pires on 16/03/26.
//

import Foundation

actor DataStore<T: Sendable> {
    private(set) var items: [T] = []
    
    func save(_ newItems: [T]) {
        self.items.append(contentsOf: newItems)
    }
    
    func clear() {
        self.items.removeAll()
    }
}
