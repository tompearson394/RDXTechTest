//
//  PersonalInfoView.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct PersonalInfoView: View {
    
    @ObservedObject private var viewStore: ViewStore<MainApp.State, MainApp.Action>
    
    init(store: Store<MainApp.State, MainApp.Action>) {
        self.viewStore = ViewStore(store)
    }
    
    private var nextDisabled: Bool {
        viewStore.firstName.isEmpty ||
        viewStore.lastName.isEmpty ||
        viewStore.phoneNumber.isEmpty
    }
    
    var body: some View {
        VStack {
            TextField(
                "First Name",
                text: viewStore.binding(\.$firstName)
            )
        
            TextField(
                "Last Name",
                text: viewStore.binding(\.$lastName)
            )
            
            TextField(
                "Phone Number",
                text: viewStore.binding(\.$phoneNumber)
            )
            .keyboardType(.phonePad)
            
            NextButton(disabled: nextDisabled) {
                viewStore.send(.coordinator(.handleNextPress(fromScreen: .personalInfo)))
            }
        }
        .padding()
        .autocorrectionDisabled()
        .textFieldStyle(.roundedBorder)
        .navigationTitle("Personal Information")
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: MainApp.State(),
            reducer: MainApp()
        )
        
        PersonalInfoView(store: store)
    }
}
