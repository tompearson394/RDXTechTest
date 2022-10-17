//
//  RDXTechTestApp.swift
//  RDXTechTest
//
//  Created by jstash on 10/10/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct RDXTechTestApp: App {
        
    private let store = Store(initialState: MainApp.State(), reducer: MainApp())

    var body: some Scene {
        WindowGroup {
            WithViewStore(store) { viewStore in
                NavigationStack(path: viewStore.binding(\.coordinatorState.$path)) {
                    VStack {
                        if viewStore.isLoggedIn {
                            MainView(store: store)
                        } else {
                            WelcomeView(store: store)
                        }
                    }
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                    .navigationDestination(for: Screen.self) { screen in
                        Coordinator.viewForScreen(screen, store)
                    }
                }
            }
        }
    }
}

private extension MainApp.State {
    var isLoggedIn: Bool {
        !pinState.pin.isEmpty
    }
}
