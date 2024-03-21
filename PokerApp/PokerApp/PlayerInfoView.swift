//
//  PlayerInfoView.swift
//  PokerApp
//
//  Created by Hamza Hussain on 3/21/24.
//

import SwiftUI

struct PlayerInfoView: View {
    @Binding var isPresented: Bool
    @State private var text1: String = ""
    @State private var text2: String = ""

    var body: some View {
        VStack {
            Text("How many players are there?")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            TextField("Enter a number", text: $text1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            Text("What is your position")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            TextField("Enter a position", text: $text2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 40) // Add padding around the text field
            Button {
                isPresented.toggle()
            } label: {
                Text("Back")
                    .padding(.vertical, 20)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
