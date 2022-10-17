//
//  ConfirmPINView.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct ConfirmPINView: View {
    let store: Store<PIN.State, PIN.Action>
        
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextField("Enter PIN", text: viewStore.binding(\.$confirmPin))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                NextButton(disabled: !viewStore.state.pinIsValid) {
                    viewStore.send(.confirmNextPressed)
                }
            }
            .padding()
        }
        .navigationTitle("Confirm PIN")
    }
}

struct ConfirmPINView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: PIN.State(),
            reducer: PIN()
        )
        
        ConfirmPINView(store: store)
    }
}
