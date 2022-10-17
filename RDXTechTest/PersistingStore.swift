//
//  PersistingStore.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 17/10/2022.
//

import Foundation
import ComposableArchitecture

protocol PersistingStoreProtocol {
    func save<T: Codable>(key: String, _ value: T)
    func load<T: Codable>(key: String) -> T?
    func remove(key: String)
}

final class PersistingStore: PersistingStoreProtocol {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T: Codable>(key: String, _ value: T) {
        do {
            let encoded = try encoder.encode(value)
            UserDefaults.standard.set(encoded, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load<T: Codable>(key: String) -> T? {
        guard let encoded = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: encoded)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

extension DependencyValues {
    var persistingStore: PersistingStoreProtocol {
        get { self[PersistingStoreKey.self] }
        set { self[PersistingStoreKey.self] = newValue }
    }
    
    enum PersistingStoreKey: DependencyKey {
        static var liveValue: PersistingStoreProtocol = PersistingStore()
        static var testValue: PersistingStoreProtocol = PersistingStore()
    }
}
