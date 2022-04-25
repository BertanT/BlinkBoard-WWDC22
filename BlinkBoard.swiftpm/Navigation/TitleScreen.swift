//
//  TitleScreen.swift
//
//
//  Created with love and passion by Bertan
//
// The very first page of the onboarding screen with an animated Stephen Hawking Memoji!

import SwiftUI

struct TitleScreen: View {
    @State private var isPlayingMemoji = false

    var body: some View {
        VStack {
            InclusiveGreeting(greetingMessage: "Welcome to BlinkBoard!", gradient: .sixColorGradient())
                .padding(.top)
                .padding(.bottom, 0.5)
            Text("An Accessible Keyboard for All")
                .roundedFont(.title2)
            Spacer()
            if let videoURL = Bundle.main.url(forResource: "StephenHawkingMemoji", withExtension: "mov") {
                // Using VideoLooper to show animated Memoji
                VideoLooper(videoURL: videoURL, isPLaying: isPlayingMemoji)
                    .scaleEffect(1.2)
                    .glow()
                    .scaledToFit()
            }
            Spacer()
            VStack {
                Text("""
                     Inspired by the renowned physicist Stephen Hawking,\
                      this keyboard lets you type with the blink of your eyes.
                     """)
                .roundedFont(.title3)
                .padding(.bottom, 3)
                Text("""
                    Make sure your whole face is visible to the front-facing camera in a well-lit environment,\
                     and no other faces than yours are visible.
                    """)
                .roundedFont(.headline)
            }
            .multilineTextAlignment(.center)
            .padding(.vertical)
            Spacer()
            GradientLabel("Blink for 1s until the audible feedback to begin",
                          systemImage: "chevron.forward", gradient: .lilacGradient)
        }
        .padding(.bottom, 30)
        // Start Memoji animation on appear, stop on disappear
        .onAppear {
            self.isPlayingMemoji = true
        }
        .onDisappear {
            self.isPlayingMemoji = false
        }
    }
}
