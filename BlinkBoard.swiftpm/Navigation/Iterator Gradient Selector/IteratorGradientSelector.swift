//
//  IteratorGradientSelector.swift
//
//
//  Created with love and passion by Bertan
//
// Onboarding page that lets the user select which highlighter gradient they want to in the keyboard
// Also accessible later from the more menu!

import SwiftUI

struct IteratorGradientSelector: View {
    @EnvironmentObject private var model: BKViewModel

    @State private var gradientPickerItems: [AIItem]?
    @State private var gradientPickerIterating = true
    @State private var selectedItemAttributes: AIItemAttributes?

    init() { }

    var body: some View {
        VStack {GradientLabel("Choose Your Look", systemImage: "eyedropper", gradient: .purpleGradient,
                              font: .largeTitle, weight: .medium)
        .padding(.top)
        .padding(.bottom, 0.5)
            Text("Pick Your Highlighter Gradient")
                .roundedFont(.title2)
            Spacer()
            if let gradientPickerItems = gradientPickerItems {
                AccessibilityIterator(items: gradientPickerItems,
                                      selectedItemAttributes: $selectedItemAttributes,
                                      gradient: model.iteratorGradient.gradientValue(),
                                      isIterating: $gradientPickerIterating)
            }
            Text("""
                To pick an option, blink when it gets highlighted.\
                 Long-blink for 1s until the audible feedback to save and continue.
                """)
            .roundedFont(.title3)
            .multilineTextAlignment(.center)
            .padding(.top)
            Spacer()
            Text("""
                 You can access this setting in the options menu by choosing the\
                 \(Image(systemName: "dock.arrow.up.rectangle")) button at the end of the lowest row.
                """)
            .roundedFont(.headline)
            .multilineTextAlignment(.center)
            .padding(.bottom, 5)
            GradientLabel("Long-blink to continue", systemImage: "chevron.forward", gradient: .lilacGradient)
        }
        .padding(.bottom, 30)
        .onAppear(perform: gradientPickerSetup)
        .handleBlinks(blinkState: model.blinkState, onBlink: handleBlink)
    }

    // Add the gradient options to the iterator!
    private func gradientPickerSetup() {
        var gradientPickerItems = [AIItem]()
        IteratorGradient.allCases.forEach { iteratorGradient in
            gradientPickerItems.append(
                AIItem(itemView: AnyView(IGSButton(iteratorGradient: iteratorGradient)), action: {
                    model.iteratorGradient = .init(rawValue: iteratorGradient.rawValue)!
                }))
        }
        self.gradientPickerItems = gradientPickerItems
    }

    // Select the highlighted gradient when the user blinks!
    private func handleBlink() {
        KeyboardSounds().playDefaultClick()
        if let action = selectedItemAttributes?.action {
            action()
        }
    }
}
