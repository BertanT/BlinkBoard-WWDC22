//
//  HandleBlinks.swift
//
//
//  Created with love and passion by Bertan
//
// A ViewModifier with the required logic to detect normal and long blinks form a VBDState value
// Just insert the VBDState value and actions to be done on normal and long blinks, .handleBlinks handles the rest!

import SwiftUI

private struct HandleBlinks: ViewModifier {
    private var blinkState: VBDState

    // Some handy properties, including a timer to detect long blinks
    @State private var isVisible = false
    @State private var longBlinkTimer: Timer?
    @State private var userLongBlinked = false
    @State private var shouldIgnoreNextBlink = false

    private let onBlink: () -> Void
    private let onLongBlink: () -> Void

    init(blinkState: VBDState, onBlink: (@escaping () -> Void) = {},
         onLongBlink: (@escaping () -> Void) = {}) {
        self.blinkState = blinkState
        self.onBlink = onBlink
        self.onLongBlink = onLongBlink
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                // Only detect blinks when the view is visible,
                // and don't register a blink when the user's eyes are closed on appear
                isVisible = true
                if blinkState == .eyesClosed {
                    shouldIgnoreNextBlink = true
                }
            }
            .onDisappear {
                // Stop detection on disappear
                isVisible = false
            }
            .onChange(of: blinkState) { [oldState = blinkState] newState in
                handleBlinkStateChange(oldState: oldState, newState: newState)
            }
    }

    // Method to handle changes to blink state
    private func handleBlinkStateChange(oldState: VBDState, newState: VBDState) {
        // Don't process the change if not visible or specifically asked to
        if shouldIgnoreNextBlink {
            shouldIgnoreNextBlink = false
            return
        }

        if !isVisible {
            return
        }

        // When the eyes are closed after being open (not after no faces or multiple faces!)...
        if newState == .eyesClosed && oldState == .eyesOpen {
            // Start a timer that will execute the long blink action after one second and return
            longBlinkTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
                onLongBlink()
                // Used to prevent executing normal blink action after long blink
                userLongBlinked = true
            })
            return
        }

        // When the eyes are opened...
        if newState == .eyesOpen {
            if userLongBlinked {
                // If a long blink was executed, reset the long blink flag back to false and return
                userLongBlinked = false
            } else {
                // Invalidate the timer set above since the user opened their eyes before the time was up
                longBlinkTimer?.invalidate()
                // Execute normal blink action if the previous state was eyes closed (not no faces or multiple faces)
                // and return
                if oldState == .eyesClosed {
                    onBlink()
                }
            }
            return
        }

        // If the new state is anything else and we're still here, just invalidate the timer and return
        longBlinkTimer?.invalidate()
    }
}

// Cleaner implementation of the modifier with View extension
extension View {
    func handleBlinks(blinkState: VBDState, onBlink: (@escaping () -> Void) = { },
                      onLongBlink: (@escaping () -> Void) = { }) -> some View {
        self.modifier(HandleBlinks(blinkState: blinkState, onBlink: onBlink, onLongBlink: onLongBlink))
    }
}
