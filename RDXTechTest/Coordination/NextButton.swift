//
//  NextButton.swift
//  RDXTechTest
//
//  Created by Tom Pearson on 10/10/2022.
//

import SwiftUI

struct NextButton: View {
    let disabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Next")
                .frame(width: 200)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(5)
        }
        .disabled(disabled)
        .buttonStyle(.plain)
    }
}
