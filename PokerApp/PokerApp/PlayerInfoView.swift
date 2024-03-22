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
            Text("How Many Players Are There?")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            TextField("Enter a number from 2-6", text: $text1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            Text("What is Your Position")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            TextField("Enter a position: 0 is dealer, 1 is one from dealer (small blind), ...", text: $text2)
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
