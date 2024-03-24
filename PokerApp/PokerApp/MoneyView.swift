//
//  ManualInputView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct MoneyView: View {
    @Binding var isPresented: Bool
    @State private var useramount: String = ""
    @State private var callamount: String = ""
    @State private var isPresenting = false

    var body: some View {
        VStack {
            Text("Enter Money Information")
                .font(.system(size: 30, weight: .bold, design: .default))
                .padding(.top, 20)
                .multilineTextAlignment(.center)
            Text("How Much Money Do You Have?")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            Text("(Enter a whole number, ex: 5)")
                .multilineTextAlignment(.center)
            TextField("Enter a number", text: $useramount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            Text("What Is The Amount of Money Needed to Call?")
                .font(.title)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            Text("(Enter a whole number, ex: 5)")
                .multilineTextAlignment(.center)
            TextField("Enter a number", text: $callamount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad) // Set keyboard type to number pad
                .padding(.vertical, 40) // Add padding around the text field
            HStack() {
                Button {
                    ImageStore.shared.postmoney(useramount, callamount) {
                        isPresenting.toggle()
                    }
                } label: {
                    Text("Continue")
                        .padding(.vertical, 20)
                }
                .buttonStyle(BorderlessButtonStyle())
                .fullScreenCover(isPresented: $isPresenting) {
                    PlayerInfoView(isPresented: $isPresenting)
                }
            }
        }
        .onTapGesture {
            // Dismiss the keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
