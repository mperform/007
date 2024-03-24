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
            Text("Enter Opponent Information")
                .font(.system(size: 30, weight: .bold, design: .default))
                .padding(.top, 20)
                .multilineTextAlignment(.center)
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
            Text("What is Your Position?")
                .font(.title)
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
            Text("(0 is dealer, 1 is one from dealer (small blind), ...)")
                .multilineTextAlignment(.center)
            TextField("0", value: $position, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            HStack(spacing:60) {
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Go Back")
                        .padding(.vertical, 20)
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    isPresenting.toggle()
                } label: {
                    Text("Continue")
                        .padding(.vertical, 20)
                }
                .buttonStyle(BorderlessButtonStyle())
                .fullScreenCover(isPresented: $isPresenting) {
                    OpponentMoneyView(isPresented: $isPresenting, numPlayers: $numPlayers, position: $position)
                }
            }
        }
        .padding()
    }
}
