//
//  ManualInputView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct MoneyView: View {
    @Binding var isPresented: Bool
    @State private var text1: String = ""
    @State private var text2: String = ""
    @State private var ispresenting = false

    var body: some View {
        VStack {
            Text("How Much Money Do You Have?")
                .font(.title)
                .padding(.vertical, 20)
            TextField("Enter a number", text: $text1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            Text("What Is The Amount of Money Needed to Call?")
                .font(.title)
                .padding(.vertical, 20)
            TextField("Enter a number", text: $text2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
        }
        .padding()
    }
}
