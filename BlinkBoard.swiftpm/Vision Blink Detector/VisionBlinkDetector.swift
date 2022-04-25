//
//  VisionBlinkDetector.swift
//
//
//  Created with love and passion by Bertan
//
// Porting VisionBlinkDetectorVC to SwiftUI!

import SwiftUI

struct VisionBlinkDetector: UIViewControllerRepresentable {
    @Binding var blinkState: VBDState

    let faceRectColor: UIColor
    let onCamInitComplete: (VBDError?) -> Void

    class Coordinator: NSObject, VisionBlinkDetectorVCDelegate {
        var parent: VisionBlinkDetector

        var detectedState: VBDState = .noFaces {
            willSet {
                withAnimation {
                    self.parent.blinkState = newValue
                }
            }
        }

        var onCamInitComplete: (VBDError?) -> Void

        init(_ parent: VisionBlinkDetector, faceRectColor: UIColor = .systemIndigo) {
            self.parent = parent
            func onCamInitCompleteAsync(_ error: VBDError?) {
                DispatchQueue.main.async {
                    parent.onCamInitComplete(error)
                }
            }
            self.onCamInitComplete = onCamInitCompleteAsync
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> VisionBlinkDetectorVC {
        let visionVC = VisionBlinkDetectorVC()
        visionVC.delegate = context.coordinator
        return visionVC
    }

    func updateUIViewController(_ visionBlinkDetectorVC: VisionBlinkDetectorVC, context: Context) {
        visionBlinkDetectorVC.delegate?.onCamInitComplete = onCamInitComplete
        visionBlinkDetectorVC.faceRectColor = faceRectColor
    }
}
