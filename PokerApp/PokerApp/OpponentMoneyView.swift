//
//  OpponentMoneyView.swift
//  PokerApp
//
//  Created by Hamza Hussain on 3/22/24.
//

import Foundation
import SwiftUI

struct OpponentMoneyView: View {
    @Binding var isPresented: Bool
    @Binding var numPlayers: Int
    @Binding var position: Int
    
    @State private var selectedOptions: [Int]
    @State private var textValues: [Int]
    
    init(isPresented: Binding<Bool>, numPlayers: Binding<Int>, position: Binding<Int>) {
        self._isPresented = isPresented
        self._numPlayers = numPlayers
        let initialOptions = Array(repeating: 0, count: numPlayers.wrappedValue)
        self._selectedOptions = State(initialValue: initialOptions)
        self._position = position
        self._textValues = State(initialValue: Array(repeating: 0, count: numPlayers.wrappedValue))
    }
    
    let options = ["Raise", "Call", "Check", "Fold"]
    

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<numPlayers, id: \.self) { index in
                Text("Opponent #\(index + 1)")
                Picker("Select an option", selection: self.$selectedOptions[index]) {
                    ForEach(0..<4) { optionIndex in
                        Text(options[optionIndex]).tag(optionIndex)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle for dropdown appearance
                .frame(maxWidth: .infinity, alignment: .leading) // Set alignment on Picker
                
                TextField("Enter amount", value: self.$textValues[index], formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 40) // Add padding around the text field
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
