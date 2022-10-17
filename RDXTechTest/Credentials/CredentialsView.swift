//
//  CredentialsView.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct CredentialsView: View {
    @ObservedObject private var viewStore: ViewStore<Credentials.State, Credentials.Action>
    
    init(store: Store<Credentials.State, Credentials.Action>) {
        self.viewStore = ViewStore(store)
    }

    private var nextDisabled: Bool {
        viewStore.email.isEmpty || viewStore.password.isEmpty
    }
    
    var body: some View {
        VStack {
            TextField(
                "E-mail",
                text: viewStore.binding(\.$email)
            )
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocorrectionDisabled()
            
            SecureField(
                "Password",
                text: viewStore.binding(\.$password)
            )
            
            NextButton(disabled: nextDisabled) {
                viewStore.send(Credentials.Action.nextPressed)
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .navigationTitle("Credentials")
    }
}

struct CredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Credentials.State(),
            reducer: Credentials()
        )
        CredentialsView(store: store)
    }
}
