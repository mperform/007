//
//  ContentView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var isPresented: Bool
    @State private var isPresenting = false
    var body: some View {
        VStack {
            Text("Welcome to PokerPro!")
                .font(.system(size: 30, weight: .bold, design: .default))
                .padding(.top, 20)
                .font(.title)
                .multilineTextAlignment(.center)
            Button {
                isPresenting.toggle()
            } label: {
                Text("Start")
                    .padding(.vertical, 20)
                    .padding(.horizontal,30)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .fullScreenCover(isPresented: $isPresenting) {
            SelectModeView(isPresented: $isPresenting)
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
