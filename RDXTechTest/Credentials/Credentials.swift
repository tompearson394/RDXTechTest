//
//  CredentialsCore.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import Foundation
import ComposableArchitecture

struct Credentials: ReducerProtocol {
    struct State: Equatable, Codable {
        @BindableState var email: String = ""
        @BindableState var password: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        case nextPressed
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
    }
}
