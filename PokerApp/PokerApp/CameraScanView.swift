//
//  ManualInputView.swift
//  PokerApp
//
//  Created by TEJAS MAIRE on 3/19/24.
//

import SwiftUI

struct CameraScanView: View {
    @Binding var isPresented: Bool
    @State private var sourceTypeYours: UIImagePickerController.SourceType? = nil
    @State private var sourceTypeComm: UIImagePickerController.SourceType? = nil
    @State private var isPresenting = false
    @State private var isPresentingYours = false
    @State private var isPresentingComm = false
    @State private var yourCards: UIImage? = nil
    @State private var communityCards: UIImage? = nil
    @State private var playerCardsStr: String = ""
    @State private var communityCardsStr: String = ""
    
    @ViewBuilder
    func YourCardsCameraButton() -> some View {
        Button {
            sourceTypeYours = .camera
            isPresentingYours.toggle()
        } label: {
            Text("Your Cards")
                .padding(.vertical, 40)
                .padding(.horizontal,80)
//                .scaleEffect(1.2)
        }
    }
    
    @ViewBuilder
    func CommCardsCameraButton() -> some View {
        Button {
            sourceTypeComm = .camera
            isPresentingComm.toggle()
        } label: {
            Text("Community Cards")
                .padding(.vertical, 40)
                .padding(.horizontal,60)
//                .scaleEffect(1.2)
        }
    }
    
    @ViewBuilder
    func SubmitButton() -> some View {
        Button {
            Task {
                
                if let _ = await ImageStore.shared.postHand(image: yourCards) {
                    ImageStore.shared.getHand()
                    if let _ = await ImageStore.shared.postCommunityCards(image: communityCards) {
                        ImageStore.shared.getCommunityCards()
                        if let _ = await ImageStore.shared.postHand(image: yourCards) {
                        }
                    }
                }
                isPresenting.toggle()
                        
            }
        } label: {
            Text("Continue")
                .padding(.vertical, 20)
        }
    }

    var body: some View {
        VStack {
            Text("Scan Cards")
                .font(.system(size: 30, weight: .bold, design: .default))
                .padding(.top, 20)
                .font(.title)
                .multilineTextAlignment(.center)
            YourCardsCameraButton()
                .padding(.vertical, 20)
                .buttonStyle(.bordered)
                .fullScreenCover(isPresented: $isPresentingYours) {
                    ImagePicker(sourceType: $sourceTypeYours, image: $yourCards)
                }
            CommCardsCameraButton()
                .padding(.vertical, 20)
                .buttonStyle(.bordered)
                .fullScreenCover(isPresented: $isPresentingComm) {
                    ImagePicker(sourceType: $sourceTypeComm, image: $communityCards)
                }
            HStack(alignment: .center) {
                if let yourCards {
                    Image(uiImage: yourCards)
                        .scaledToFit()
                        .frame(height: 181)
                        .padding(.trailing, 18)
                }
                
                if let communityCards {
                    Image(uiImage: communityCards)
                        .scaledToFit()
                        .frame(height: 181)
                        .padding(.trailing, 18)
                }
            }
            Spacer()
            HStack(spacing: 60) {
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Go Back")
                        .padding(.vertical, 20)
                }
                .buttonStyle(BorderlessButtonStyle())
                SubmitButton()
                    .buttonStyle(BorderlessButtonStyle())
                    .fullScreenCover(isPresented: $isPresenting) {
                        CardsView(isPresented: $isPresenting, playerCardsString: ImageStore.shared.yourCards, communityCardsString: ImageStore.shared.yourCommunityCards)
                    }
            }
        }
    }
}
