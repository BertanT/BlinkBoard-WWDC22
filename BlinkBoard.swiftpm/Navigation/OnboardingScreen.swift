//
//  OnboardingScreen.swift
//
//
//  Created with love and passion by Bertan
//
// Onboarding screen made up of pages that can be navigated with long blinks!

import SwiftUI

struct OnboardingScreen: View {
    @EnvironmentObject private var model: BKViewModel

    @Binding private var isSheetShown: Bool
    @State private var currentPageIndex = 0

    private let maxPageIndex = 3

    init(isSheetShown: Binding<Bool>) {
        self._isSheetShown = isSheetShown
    }

    var body: some View {
        TabView(selection: $currentPageIndex) {
            TitleScreen()
                .tag(0)
                .padding(.bottom, 20)
            AboutScreen()
                .tag(1)
                .padding(.bottom, 20)
            GuideScreen()
                .tag(2)
                .padding(.bottom, 20)
            IteratorGradientSelector()
                .tag(3)
                .environmentObject(model)
                .padding(.bottom, 20)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .zIndex(1)
        .handleBlinks(blinkState: model.blinkState, onLongBlink: advanceOnboarding)
    }

    // If there are any pages left, navigate to the next one
    // If none left, dismiss the onboarding sheet
    private func advanceOnboarding() {
        let next = currentPageIndex + 1

        if next > maxPageIndex {
            withAnimation {
                isSheetShown = false
            }

        } else {
            KeyboardSounds().playModifierClick()
            withAnimation {
                currentPageIndex = next
            }
        }
    }
}
