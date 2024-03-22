//
//  CardsView.swift
//  PokerApp
//
//  Created by Hamza Hussain on 3/22/24.
//

import Foundation
import SwiftUI

struct CardsView: View {
    @Binding var isPresented: Bool
    @Binding var playerCardsString: String
    @Binding var communityCardsString: String
    @State private var isPresenting = false
    
    var playerCards: [String] {
        // Convert input string to lowercase, split it into an array of substrings
        let inputArray = playerCardsString.lowercased().components(separatedBy: ", ")
        
        // Use map to query the dictionary and generate a list of final strings
        return inputArray.compactMap { playingCards[$0] }
    }
    var communityCards: [String] {
        // Convert input string to lowercase, split it into an array of substrings
        let inputArray = communityCardsString.lowercased().components(separatedBy: ", ")
        
        // Use map to query the dictionary and generate a list of final strings
        return inputArray.compactMap { playingCards[$0] }
    }
    
    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Your Cards")
//                .font(.headline)
//            ForEach(playerCards, id: \.self) { playerCards in
//                HStack {
//                    Image(systemName: "circle.fill")
//                    Text(playerCards)
//                        .font(.body)
//                }
////                .padding(.leading, 20)
//            }
//            .padding()
//            
//            Text("Community Cards")
//                .font(.headline)
//            ForEach(communityCards, id: \.self) { communityCards in
//                HStack {
//                    Image(systemName: "circle.fill")
//                    Text(communityCards)
//                        .font(.body)
//                }
////                .padding(.leading, 20)
//            }
//        }
//        .padding()
        VStack {
            Text("Is the following information correct?")
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
            }
            
//            Button {
//                isPresenting.toggle()
//            } label: {
//                Text("Confirm")
//                    .padding(.vertical, 20)
//            }
//            .buttonStyle(.bordered)
//            fullScreenCover(isPresented: $isPresenting) {
//                 MoneyView(isPresented: $isPresenting)
//            }
//            
            HStack {
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Go Back")
                        .padding(.vertical, 20)
                }
                .buttonStyle(.bordered)
                
                Button {
                    isPresenting.toggle()
                } label: {
                    Text("Confirm")
                        .padding(.vertical, 20)
                }
                .buttonStyle(.bordered)
                .fullScreenCover(isPresented: $isPresenting) {
                     MoneyView(isPresented: $isPresenting)
                }
            }
        }
        
        
    }
    
}


