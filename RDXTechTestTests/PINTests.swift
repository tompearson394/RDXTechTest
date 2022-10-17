//
//  PINTests.swift
//  RDXTechTestTests
//
//  Created by Tom Pearson on 11/10/2022.
//

import XCTest
import ComposableArchitecture

@testable import RDXTechTest

final class PINTests: XCTestCase {
    private var store: TestStore<PIN.State, PIN.Action, PIN.State, PIN.Action, ()>!

    override func setUp() {
        store = TestStore(
            initialState: PIN.State(),
            reducer: PIN()
        )
    }
    
    func testConfirmPin() async {
        let pin = "321"
        
        _ = await store.send(.set(\.$proposePin, pin)) {
            $0.proposePin = pin
            $0.pinIsValid = false
        }
        
        _ = await store.send(.set(\.$confirmPin, "123")) {
            $0.proposePin = pin
            $0.confirmPin = "123"
            $0.pinIsValid = false
        }
        
        _ = await store.send(.set(\.$confirmPin, pin)) {
            $0.proposePin = pin
            $0.confirmPin = pin
            $0.pinIsValid = true
        }
        
        _ = await store.send(.confirmNextPressed) {
            $0.proposePin = pin
            $0.confirmPin = pin
            $0.pinIsValid = true
            $0.pin = pin
        }
    }
}
