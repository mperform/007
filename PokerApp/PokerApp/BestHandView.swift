//
//  BestHandView.swift
//  PokerApp
//
//  Created by Hamza Hussain on 3/23/24.
//

import Foundation
import SwiftUI

struct BestHandView: View {
    @Binding var isPresented: Bool
    @State private var isPresenting = false;
    @State private var isLoading = true
    
    var playerCards: [String] {
        // Convert input string to lowercase, split it into an array of substrings
        let inputArray = ImageStore.shared.yourFinalCards.lowercased().components(separatedBy: ", ")
        
        // Use map to query the dictionary and generate a list of final strings
        return inputArray.compactMap { playingCards[$0] }
    }
    var communityCards: [String] {
        // Convert input string to lowercase, split it into an array of substrings
        let inputArray = ImageStore.shared.yourFinalCommunityCards.lowercased().components(separatedBy: ", ")
        
        // Use map to query the dictionary and generate a list of final strings
        return inputArray.compactMap { playingCards[$0] }
    }
    

    var body: some View {
        VStack(alignment: .center) {
            if isLoading {
                ProgressView("Loading...")
            } else {
                Text("Your Results")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .padding(.top, 20)
                List {
                    Section(header: Text("Your Cards")) {
                        ForEach(playerCards, id: \.self) { playerCards in
                            Text(playerCards)
                        }
                    }
                    Section(header: Text("Community Cards")) {
                        ForEach(communityCards, id: \.self) { communityCards in
                            Text(communityCards)
                        }
                    }
                    Section(header: Text("Your Best Hand")) {
                        Text(ImageStore.shared.bestHand)
                    }
                    Section(header: Text("Your Chance of Winning")) {
                        Text(ImageStore.shared.winningProbability)
                    }
                    Section(header: Text("Recommended Decision")) {
                        Text(ImageStore.shared.nextDecision)
                    }
                }
                Button {
                    isPresenting.toggle()
                } label: {
                    Text("Next Round")
                        .padding(.vertical, 20)
                        .padding(.horizontal,30)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
        .onAppear {
            ImageStore.shared.getFinalHand {
                ImageStore.shared.getFinalCommunityCards {
                    ImageStore.shared.getBestHand {
                        self.isLoading = false
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isPresenting) {
            ContentView(isPresented: $isPresenting)
        }
    }
}

