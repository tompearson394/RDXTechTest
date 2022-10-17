//
//  MockPersistingStore.swift
//  RDXTechTestTests
//
//  Created by Tom Pearson on 17/10/2022.
//

import Foundation

@testable import RDXTechTest

final class MockPersistingStore: PersistingStoreProtocol {
    
    var saveCallCount = 0
    func save<T>(key: String, _ value: T) where T: Codable {
        saveCallCount += 1
    }
    
    var loadedObject: Any?
    var loadCallCount = 0
    func load<T>(key: String) -> T? where T: Codable {
        loadCallCount += 1
        return (loadedObject as? T)
    }
    
    var removeCallCount = 0
    func remove(key: String) {
        removeCallCount += 1
    }
}
