//
//  GuidedVisionBlinkDetector.swift
//
//
//  Created with love and passion by Bertan
//
// Upgraded VisionBlinkDetector that provides instruction to the user and shows errors

import SwiftUI

struct GuidedVisionBlinkDetector: View {
    @Binding private var blinkState: VBDState

    @State private var alertText: String?

    private let faceRectColor: UIColor
    private let onCamInitComplete: (VBDError?) -> Void

    init(blinkState: Binding<VBDState>, faceRectColor: UIColor,
         onCamInitComplete: (@escaping (VBDError?) -> Void) = { _ in }) {
        self._blinkState = blinkState
        self.faceRectColor = faceRectColor
        self.onCamInitComplete = onCamInitComplete
    }

    var body: some View {
        VisionBlinkDetector(blinkState: $blinkState, faceRectColor: faceRectColor,
                            onCamInitComplete: handleCamInitComplete)
        .overlay {
            VStack {
                if let alertText = alertText {
                    // Error view!
                    GuideOverlay<Never>(alertText, systemImage: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.multicolor)
                } else if blinkState == .noFaces {
                    // Animated no faces guide!
                    GuideOverlay("Bring your face into the view") {
                        FaceAnimation()
                    }
                } else if blinkState == .multipleFaces {
                    // Multiple faces guide!
                    GuideOverlay<Never>("Please make sure only your face is visible", systemImage: "person.2.fill")
                }
            }
        }
        .onChange(of: blinkState) { [blinkState] newState in
            setIdleTimer(oldState: blinkState, newState: newState)
        }
    }

    // If there are any errors while initializing the camera, show errors to the user
    // and execute the user defined completion afterwards
    private func handleCamInitComplete(error: VBDError?) {
        DispatchQueue.main.async {
            if let error = error {
                switch error {
                case .camPermissionDenied:
                    alertText = """
                                Camera access is denied!\nTo use this app,\
                                 please allow camera access in settings.
                                """
                case .noCaptureDevices:
                    alertText = "There are no compatible cameras in your device."
                default:
                    alertText = "An unexpected error occurred while processing image data"
                }
            }
        }
        onCamInitComplete(error)
    }

    // Disable auto screen lock when the user's face in the view!
    private func setIdleTimer(oldState: VBDState, newState: VBDState) {
        if (oldState == .eyesOpen || oldState == .eyesClosed) &&
            (newState == .eyesOpen || newState == .eyesClosed) { return }

        if newState == .eyesOpen || newState == .eyesClosed {
            UIApplication.shared.isIdleTimerDisabled = true
        } else {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
