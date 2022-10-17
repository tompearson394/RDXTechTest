//
//  MainView.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: Store<MainApp.State, MainApp.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
                Text("Hello \(viewStore.firstName) \(viewStore.lastName)")
                    .font(.title)
                Spacer()
                
                Button("Log Out") {
                    viewStore.send(.logOut)
                }
                .font(.title3)
            }
        }
        .navigationTitle("Main")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: MainApp.State(firstName: "Lucy", lastName: "Jones"),
            reducer: MainApp()
        )
        MainView(store: store)
    }
}
