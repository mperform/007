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
    @State private var isPresenting = false

    var body: some View {
        VStack {
            Text("How Much Money Do You Have?")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            TextField("Enter a number", text: $text1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            Text("What Is The Amount of Money Needed to Call?")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            TextField("Enter a number", text: $text2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
        }
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
                     PlayerInfoView(isPresented: $isPresenting)
                }
            }
    }
}
