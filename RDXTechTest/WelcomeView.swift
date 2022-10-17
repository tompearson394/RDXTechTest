//
//  WelcomeView.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    
    let store: Store<MainApp.State, MainApp.Action>
 
    var body: some View {
        VStack {
            Text("Welcome 👋")
                .font(.title)
            
            WithViewStore(store) { viewStore in
                NextButton(disabled: false) {
                    viewStore.send(.coordinator(.handleNextPress(fromScreen: .welcome)))
                    
                }
            }
        }
        .navigationTitle("Welcome")
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: MainApp.State(),
            reducer: MainApp()
        )
        WelcomeView(store: store)
    }
}
