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
    @State private var isLoading = true
    

    var body: some View {
        VStack(alignment: .center) {
            if isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    Section(header: Text("Your Cards")) {
                        ForEach(ImageStore.shared.yourFinalCards, id: \.self) { playerCards in
                            Text(playerCards)
                        }
                    }
                    Section(header: Text("Community Cards")) {
                        ForEach(ImageStore.shared.yourFinalCommunityCards, id: \.self) { communityCards in
                            Text(communityCards)
                        }
                    }
                }
                Text(ImageStore.shared.bestHand)
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
    }
}

