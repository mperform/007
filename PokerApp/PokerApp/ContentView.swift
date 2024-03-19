//
//  ContentView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresenting = false
    var body: some View {
        VStack {
            Text("Welcome to PokerPro!")
                .font(.title)
                .multilineTextAlignment(.center)
            Button {
                isPresenting.toggle()
            } label: {
                Text("Start")
                    .padding(.vertical, 20)
            }
            .buttonStyle(.bordered)
        }
        .fullScreenCover(isPresented: $isPresenting) {
            SelectModeView(isPresented: $isPresenting)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
