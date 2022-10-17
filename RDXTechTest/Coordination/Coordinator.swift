//
//  Coordinator.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 11/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct Coordinator: ReducerProtocol {
    struct State: Equatable {
        @BindableState var path = NavigationPath()
    }
    
    enum Action: Equatable, BindableAction {
        case handleNextPress(fromScreen: Screen)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .handleNextPress(let screen):
                if let newScreen = Coordinator.nextScreen(fromScreen: screen) {
                    state.path.append(newScreen)
                }
                return .none
            case .binding:
                return .none
            }
        }
    }
}

extension Coordinator.State: Codable {
    init(from decoder: Decoder) throws {
        // todo - implement serialization of NavigationPath
    }

    func encode(to encoder: Encoder) throws {
        // todo - implement serialization of NavigationPath
    }
}

extension Coordinator {
    @ViewBuilder
    static func viewForScreen(_ screen: Screen, _ store: Store<MainApp.State, MainApp.Action>) -> some View {
        switch screen {
        case .welcome:
            WelcomeView(store: store)
        case .termsOfService:
            TermsOfServiceView(store: store)
        case .credentials:
            let credentialsStore = store.scope(
                state: \MainApp.State.credentialsState,
                action: MainApp.Action.credentials
            )
            CredentialsView(store: credentialsStore)
        case .personalInfo:
            PersonalInfoView(store: store)
        case .newPIN:
            let pinStore = store.scope(
                state: \MainApp.State.pinState,
                action: MainApp.Action.PIN
            )
            ProposePINView(store: pinStore)
        case .confirmPIN:
            let pinStore = store.scope(
                state: \MainApp.State.pinState,
                action: MainApp.Action.PIN
            )
            ConfirmPINView(store: pinStore)
        case .main:
            MainView(store: store)
        }
    }
    
    static func nextScreen(fromScreen screen: Screen) -> Screen? {
        switch screen {
        case .welcome:
            return .termsOfService
        case .termsOfService:
            return .credentials
        case .credentials:
            return .personalInfo
        case .personalInfo:
            return .newPIN
        case .newPIN:
            return .confirmPIN
        case .confirmPIN, .main:
            return nil
        }
    }
}
