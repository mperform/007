//
//  ContentView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct SelectModeView: View {
    @Binding var isPresented: Bool
    @State private var isPresentingManual = false;
    @State private var isPresentingCamera = false;
    var body: some View {
        VStack {
            Text("How Would You Like To Input Your Cards?")
                .font(.title)
                .padding(.vertical, 20)
            Button {
                isPresentingManual.toggle()
            } label: {
                Text("Manual Input")
                    .padding(.vertical, 20)
            }
            Button {
                isPresentingCamera.toggle()
            } label: {
                Text("Camera Scan")
                    .padding(.vertical, 20)
            }
        .fullScreenCover(isPresented: $isPresentingCamera) {
            CameraScanView(isPresented: $isPresentingCamera)
        }
        }
        .fullScreenCover(isPresented: $isPresentingManual) {
            ManualInputView(isPresented: $isPresentingManual)
        }
        .padding()
    }
}
