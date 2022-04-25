//
//  InclusiveGreeting.swift
//
//
//  Created with love and passion by Bertan
//
// The greeting view with color changing hand emojis used in the TitleScreen and in many of my apps!

import SwiftUI
import Combine

struct InclusiveGreeting: View {
    @State private var currentHand = ""
    private var greetingMessage: String
    private let gradient: Gradient
    private let cycleDelay: Double
    private let hands = ["👋", "👋🏻", "👋🏼", "👋🏽", "👋🏾", "👋🏿"]
    // This timer will make sure hands will switch periodically
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>

    init(greetingMessage: String, gradient: Gradient, cycleDelay: Double = 3) {
        self.greetingMessage = greetingMessage
        self.gradient = gradient
        self.cycleDelay = cycleDelay
        timer = Timer.publish(every: cycleDelay, on: .main, in: .common).autoconnect()
    }

    var body: some View {
        HStack {
            Text(currentHand)
                .roundedFont(.largeTitle)
                .glow(radius: 10)
                .transition(.opacity)
                .animation(.easeIn, value: currentHand)
                .id(currentHand)
            Text(greetingMessage)
                .roundedFont(.largeTitle, weight: .semibold)
                .gradientBackground(gradient)
        }
        // Choose a random hand as soon as the view appears
        .onAppear {
            currentHand = hands.randomElement()!
        }
        // Switch to another weaving hand emoji when the timer fires, making sure it's a different one
        // Animation duration is equal to cycleDelay so that it can looks like a continuous cycle
        .onReceive(timer) { _ in
            withAnimation { currentHand = hands.filter { $0 != currentHand }.randomElement()! }
        }
    }
}
