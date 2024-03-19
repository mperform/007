//
//  ManualInputView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct CameraScanView: View {
    @Binding var isPresented: Bool
    @State private var sourceType: UIImagePickerController.SourceType? = nil
    @State private var isPresenting = false
    
    @ViewBuilder
    func YourCardsCameraButton() -> some View {
        Button {
            sourceType = .camera
//            isPresenting.toggle()
        } label: {
            Text("Your Cards")
                .padding(.vertical,20)
//                .scaleEffect(1.2)
        }
    }
    
    @ViewBuilder
    func CommCardsCameraButton() -> some View {
        Button {
            sourceType = .camera
//            isPresenting.toggle()
        } label: {
            Text("Community Cards")
                .padding(.vertical, 20)
//                .scaleEffect(1.2)
        }
    }

    var body: some View {
        VStack {
            Text("Scan Cards")
                .font(.title)
                .padding(.vertical, 20)
            YourCardsCameraButton()
                .padding(.vertical, 20)
            CommCardsCameraButton()
                .padding(.vertical, 20)
            Button {
                isPresenting.toggle()
            } label: {
                Text("Continue")
                    .padding(.vertical, 20)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isPresenting) {
            MoneyView(isPresented: $isPresenting)
        }
    }
}
