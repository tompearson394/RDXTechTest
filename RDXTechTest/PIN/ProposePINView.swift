//
//  ProposePINView.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct ProposePINView: View {
    let store: Store<PIN.State, PIN.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextField("Enter PIN", text: viewStore.binding(\.$proposePin))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                NextButton(disabled: viewStore.proposePin.isEmpty) {
                    viewStore.send(.proposeNextPressed)
                }
            }
            .padding()
        }
        .navigationTitle("Enter PIN")
    }
}

struct ProposePINView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: PIN.State(),
            reducer: PIN()
        )
        
        ProposePINView(store: store)
    }
}
