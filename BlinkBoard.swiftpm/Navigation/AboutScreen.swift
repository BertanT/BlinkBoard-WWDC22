//
//  AboutScreen.swift
//
//
//  Created with love and passion by Bertan
//
// Onboarding page to introduce the user to the app

import SwiftUI

struct AboutScreen: View {

    init() { }

    var body: some View {
        VStack {
            GradientLabel("Inspired by Stephen Hawking", systemImage: "eyes",
                          gradient: .purpleGradient, font: .largeTitle, weight: .medium)
            .padding(.top)
            .padding(.bottom, 0.5)
            Text("All Great Ideas Deserve to Be Heard")
                .roundedFont(.title2)
            Spacer()
            VStack {
                Image("StephenHawkingNasa2008")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .glow(radius: 15)
                    .padding()
                Text("NASA/Paul Alers, public domain, via Wikimedia Commons")
                    .roundedFont(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: UIScreen.main.bounds.height / 3)
            Spacer()
            Text("""
                BlinkBoard can help people with ALS or similar conditions easily communicate with the world by\
                 typing on the onscreen keyboard and turning the text into speech with only one input method:\
                 eye blinks! Inspired by how Professor Hawking used to control his computer, the BlinkBoard app\
                 aims to make the technology accessible to everyone.\n\nMade with ❤️ and passion by Bertan.
                """)
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .font(.system(size: UIScreen.main.adaptiveParagraphFontSize(), design: .rounded))
            Spacer()
            GradientLabel("Long-blink to continue", systemImage: "chevron.forward", gradient: .lilacGradient)
        }
        .padding(.bottom, 30)
    }
}
