//
//  FaceAnimation.swift
//
//
//  Created with love and passion by Bertan
//
// An animation shown when the user's face is not in frame

import SwiftUI

struct FaceAnimation: View {
    // Viewfinder scale coefficient
    @State private var scale: CGFloat = 1

    var body: some View {
        ZStack {
            Image(systemName: "viewfinder")
                .resizable()
                .scaleEffect(scale)
                .font(.system(size: 1, weight: .light))
                .onAppear(perform: startAnimating)
            Image(systemName: "person.fill")
                .resizable()
                .scaleEffect(0.6) // Scale the person symbol for it to fit the viewfinder
        }
        .scaledToFit()
        .foregroundStyle(.white)
    }

    // Scale the viewfinder symbol up and down every second with an animation
    private func startAnimating() {
        let animation = Animation.easeInOut(duration: 1)
        let repeatedAnimation = animation.repeatForever(autoreverses: true)
        withAnimation(repeatedAnimation) {
            scale = 1.25
        }
    }
}
