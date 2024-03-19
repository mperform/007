//
//  ManualInputView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct ManualInputView: View {
    @Binding var isPresented: Bool
    @State private var text1: String = ""
    @State private var text2: String = ""
    @State private var isPresenting = false

    var body: some View {
        VStack {
            Text("Type Each Card")
                .font(.title)
                .padding(.vertical, 20)
            Text("Your Cards")
                .font(.title)
                .padding(.vertical, 20)
            TextField("Example: KH, 2S, AH ", text: $text1)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style to the text field
                .padding(.vertical, 20) // Add padding around the text field
            Text("Community Cards")
                .font(.title)
                .padding(.vertical, 20)
            TextField("Example: KH, 2S, AH ", text: $text2)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style to the text field
                .padding(.vertical, 20) // Add padding around the text field
            Button {
                isPresenting.toggle()
            } label: {
                Text("Continue")
                    .padding(.vertical, 20)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isPresenting) {
            MoneyView(isPresented: $isPresenting)
        }
    }
}
