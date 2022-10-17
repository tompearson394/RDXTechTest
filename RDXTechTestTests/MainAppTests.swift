//
//  MainAppTests.swift
//  RDXTechTestTests
//
//  Created by Tom Pearson on 11/10/2022.
//

import XCTest
import SwiftUI
import ComposableArchitecture

@testable import RDXTechTest

final class MainAppTests: XCTestCase {
    
    private var mockPersistingStore: MockPersistingStore!
    private var store: TestStore<MainApp.State, MainApp.Action, MainApp.State, MainApp.Action, ()>!

    override func setUp() {
        mockPersistingStore = MockPersistingStore()
        store = TestStore(
            initialState: MainApp.State(),
            reducer: Reducer(MainApp()),
            environment: ()
        )
        
        store.dependencies.persistingStore = mockPersistingStore
    }

    func testOnAppear_OnlyLoadsStateOnce() async {
        _ = await store.send(.onAppear) {
            $0.hasAppeared = true
        }

        await store.receive(.loadedState(nil))

        _ = await store.send(.onAppear)
        
        XCTAssertEqual(mockPersistingStore.loadCallCount, 1)
    }
    
    func testLoadingState() async {
        let loadedState = MainApp.State(firstName: "Lucy", lastName: "Jones")

        _ = await store.send(.loadedState(loadedState)) {
            $0 = loadedState
        }
    }

    func testConfirmPIN_SavesState() async {
        let pin = "321"
        _ = await store.send(.PIN(.set(\.$proposePin, pin))) {
            $0.pinState = PIN.State(proposePin: pin)
        }
        _ = await store.send(.PIN(.set(\.$confirmPin, pin))) {
            $0.pinState = PIN.State(proposePin: pin, confirmPin: pin, pinIsValid: true)
        }
        _ = await store.send(.PIN(.confirmNextPressed)) {
            $0.pinState = PIN.State(proposePin: pin, confirmPin: pin, pinIsValid: true, pin: pin)
        }
        
        XCTAssertEqual(mockPersistingStore.saveCallCount, 1)
    }

    func testLogOut_ClearsState() async {
        _ = await store.send(.set(\.$firstName, "Lucy")) {
            $0.firstName = "Lucy"
        }

        _ = await store.send(.logOut) {
            $0.firstName = ""
        }
        
        XCTAssertEqual(mockPersistingStore.removeCallCount, 1)
    }
    
    func testPressingNextOnCredentials_NavigatesToPersonalInfo() async {
        _ = await store.send(.credentials(.nextPressed))
        
        await store.receive(MainApp.Action.coordinator(.handleNextPress(fromScreen: .credentials))) {
            $0.coordinatorState = Coordinator.State(path: NavigationPath([Screen.personalInfo]))
        }
    }
    
    func testPressingNextOnProposePIN_NavigatesToConfirmPIN() async {
        _ = await store.send(.PIN(.proposeNextPressed))
        
        await store.receive(MainApp.Action.coordinator(.handleNextPress(fromScreen: .newPIN))) {
            $0.coordinatorState = Coordinator.State(path: NavigationPath([Screen.confirmPIN]))
        }
    }
}
