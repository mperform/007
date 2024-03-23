//
//  PlayerInfoView.swift
//  PokerApp
//
//  Created by Hamza Hussain on 3/21/24.
//

import SwiftUI

struct PlayerInfoView: View {
    @Binding var isPresented: Bool
    @State private var numPlayers: Int = 0
    @State private var position: Int = 0
    @State private var isPresenting = false

    var body: some View {
        VStack {
            Text("How Many Opponents Are There?")
                .font(.title)
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
            Text("(Enter a number from 1-4)")
                .multilineTextAlignment(.center)
            TextField("0", value: $numPlayers, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            Text("What is Your Position")
                .font(.title)
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
            Text("(0 is dealer, 1 is one from dealer (small blind), ...)")
                .multilineTextAlignment(.center)
            TextField("0", value: $position, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            Button {
                isPresenting.toggle()
            } label: {
                Text("Continue")
                    .padding(.vertical, 20)
            }
            .buttonStyle(.bordered)
            .fullScreenCover(isPresented: $isPresenting) {
                OpponentMoneyView(isPresented: $isPresenting, numPlayers: $numPlayers, position: $position)
            }
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
