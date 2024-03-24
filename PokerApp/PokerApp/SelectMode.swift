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
                .font(.system(size: 30, weight: .bold, design: .default))
                .padding(.top, 20)
                .font(.title)
                .multilineTextAlignment(.center)
            Button {
                isPresentingManual.toggle()
            } label: {
                Text("Manual Input")
                    .padding(.vertical, 40)
                    .padding(.horizontal,50)
            }
            .buttonStyle(.bordered)
            Button {
                isPresentingCamera.toggle()
            } label: {
                Text("Camera Scan")
                    .padding(.vertical, 40)
                    .padding(.horizontal,50)
            }
            .buttonStyle(.bordered)
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
