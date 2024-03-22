//
//  ManualInputView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct ManualInputView: View {
    @Binding var isPresented: Bool
    @State private var playerCards: String = ""
    @State private var communityCards: String = ""
    @State private var isPresenting = false

    var body: some View {
        VStack {
            Text("Type Each Card")
                .font(.title)
                .padding(.vertical, 20)
            Text("Your Cards")
                .font(.title)
                .padding(.vertical, 20)
            TextField("Example: KH, 2S, AH ", text: $playerCards)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style to the text field
                .padding(.vertical, 20) // Add padding around the text field
            Text("Community Cards")
                .font(.title)
                .padding(.vertical, 20)
            TextField("Example: KH, 2S, AH ", text: $communityCards)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style to the text field
                .padding(.vertical, 20) // Add padding around the text field
            Button {
                isPresenting.toggle()
            } label: {
                Text("Continue")
                    .padding(.vertical, 20)
            }
            .buttonStyle(.bordered)
            .fullScreenCover(isPresented: $isPresenting) {
                CardsView(isPresented: $isPresenting, playerCardsString: ImageStore.shared.yourCards, communityCardsString: ImageStore.shared.yourCommunityCards)
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
