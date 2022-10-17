//
//  AppCore.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MainApp: ReducerProtocol {
    struct State: Equatable, Codable {
        @BindableState var hasAcceptedTermsOfService = false
        @BindableState var firstName = ""
        @BindableState var lastName = ""
        @BindableState var phoneNumber = ""
        @BindableState var pinIsValid = false
        var credentialsState = Credentials.State()
        var pinState = PIN.State()
        var coordinatorState = Coordinator.State()
        var hasAppeared = false
    }
    
    enum Action: Equatable, BindableAction {
        case onAppear
        case loadedState(State?)
        case credentials(Credentials.Action)
        case PIN(PIN.Action)
        case coordinator(Coordinator.Action)
        case logOut
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.persistingStore) var persistingStore
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Scope(state: \.pinState, action: /Action.PIN) {
            PIN()
        }
        
        Scope(state: \.credentialsState, action: /Action.credentials) {
            Credentials()
        }
        
        Scope(state: \.coordinatorState, action: /Action.coordinator) {
            Coordinator()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.hasAppeared else {
                    return .none
                }
                state.hasAppeared = true
                return .task {
                    let loadedState: State? = persistingStore.load(key: .appStateKey)
                    return Action.loadedState(loadedState)
                }
            case .loadedState(let newState):
                if let newState {
                    state = newState
                }
                return .none
            case .PIN(let pinAction):
                switch pinAction {
                case .proposeNextPressed:
                    return .task {
                        Action.coordinator(.handleNextPress(fromScreen: .newPIN))
                    }
                case .confirmNextPressed:
                    state.coordinatorState = Coordinator.State()
                    return Effect.fireAndForget { [state] in
                        persistingStore.save(key: .appStateKey, state)
                    }
                case .binding:
                    return .none
                }
            case .logOut:
                state = State()
                return .fireAndForget {
                    persistingStore.remove(key: .appStateKey)
                }
            case .credentials(let action):
                switch action {
                case .nextPressed:
                    return .task {
                        Action.coordinator(.handleNextPress(fromScreen: .credentials))
                    }
                default:
                    return .none
                }
            case .coordinator:
                return .none
            case .binding:
                return .none
            }
        }
    }
}

private extension String {
    static let appStateKey = "com.tompearson.rdxtechtest.AppState"
}
