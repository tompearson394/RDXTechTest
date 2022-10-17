//
//  PINCore.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import Foundation
import ComposableArchitecture

struct PIN: ReducerProtocol {
    struct State: Equatable, Codable {
        @BindableState var proposePin = ""
        @BindableState var confirmPin = ""
        var pinIsValid = false
        var pin = ""
    }
    
    enum Action: Equatable, BindableAction {
        case proposeNextPressed
        case confirmNextPressed
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .confirmNextPressed:
                state.pin = state.proposePin
                return .none
            case .binding(\.$confirmPin):
                state.pinIsValid = !state.proposePin.isEmpty && state.proposePin == state.confirmPin
                return .none
            case .binding, .proposeNextPressed:
                return .none
            }
        }
    }
}
