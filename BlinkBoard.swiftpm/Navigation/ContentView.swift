//
//  ContentView.swift
//
//
//  Created with love and passion by Bertan
//
// Main entry point to the app!

import SwiftUI

struct ContentView: View {
    @StateObject private var model = BKViewModel()

    // Saved boolean value that holds wether the user has completed the onboarding or not
     @AppStorage("onboardingComplete") private var onboardingComplete = false

    // Boolean to control onboarding sheet presentation
    @State private var showingOnboardingSheet = false

    // Confetti settings!
    @State private var emittingConfetti = false
    private let confettiAmount: Float = 10
    private let confettiColors: [UIColor] = [.systemYellow, .systemMint, .systemIndigo, .systemPink]

    var body: some View {
        ZStack(alignment: .bottom) {
            GuidedVisionBlinkDetector(blinkState: $model.blinkState, faceRectColor: model.accentColor,
                                      onCamInitComplete: handleCameraInit)
            BlinkBoardKeypad(blinkState: $model.blinkState)
                .environmentObject(model)
                .padding()
        }
        // The onboarding screen!
        .adaptiveSheet(isPresented: $showingOnboardingSheet) {
            OnboardingScreen(isSheetShown: $showingOnboardingSheet)
                .padding()
                .environmentObject(model)
        }
        // Onboarding pages that can be accessed form the more menu are placed inside sheets!
        // Logic is the same in all of them and description here to all!
        .adaptiveSheet(isPresented: $model.showingIteratorGradientSheet) {
            IteratorGradientSelector()
                .padding()
                .environmentObject(model)
            // Reactivate the keyboard when the sheet is dismissed
                .onDisappear(perform: handleMenuSheetClosed)
            // Close the sheet when the user long blinks! This will not interfere with the keypad
            // since the keypad is stopped by the menu when the sheet is shown and ignores blinks.
                .handleBlinks(blinkState: model.blinkState, onLongBlink: {
                    withAnimation { model.showingIteratorGradientSheet = false }
                })
        }
        .adaptiveSheet(isPresented: $model.showingGuideSheet) {
            GuideScreen()
                .padding()
                .handleBlinks(blinkState: model.blinkState, onLongBlink: {
                    withAnimation { model.showingGuideSheet = false }
                })
                .onDisappear(perform: handleMenuSheetClosed)
        }
        .adaptiveSheet(isPresented: $model.showingAboutSheet) {
            AboutScreen()
                .padding()
                .handleBlinks(blinkState: model.blinkState, onLongBlink: {
                    withAnimation { model.showingAboutSheet = false }
                })
                .onDisappear(perform: handleMenuSheetClosed)
        }
        // The star of the show, dear confetti :P
        .confettiOverlay(amount: confettiAmount, colors: confettiColors, isEmitting: $emittingConfetti)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onChange(of: showingOnboardingSheet, perform: handleOnboardingSheetPresentationChange)
    }

    // If the camera was successfully initialized and onboarding was not complete, start it!
    private func handleCameraInit(error: Error?) {
        if error == nil && !onboardingComplete {
            showingOnboardingSheet = true
            emittingConfetti = true
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                emittingConfetti = false
            })
        } else if error == nil {
            model.setMainKeypadMode(.active)
        }
    }

    // Method to stop the keypad when onboarding is shown,
    // and to activate it & save onboarding completion on dismiss
    private func handleOnboardingSheetPresentationChange(isPresented: Bool) {
        if isPresented {
            model.setMainKeypadMode(.stopped)
        } else {
            KeyboardSounds().playActivationSound()
            onboardingComplete = true
            model.setMainKeypadMode(.active)
        }
    }

    // Method to reactivate the keypad when a more menu sheet is dismissed
    private func handleMenuSheetClosed() {
        KeyboardSounds().playModifierClick()
        model.setMainKeypadMode(.active)
    }
}
