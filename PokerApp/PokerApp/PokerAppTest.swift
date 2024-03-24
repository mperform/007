//
//  PokerAppApp.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

@main
struct PokerAppApp: App {
    @State private var isPresenting = true
    var body: some Scene {
        WindowGroup {
            ContentView(isPresented: $isPresenting)
        }
    }
}
