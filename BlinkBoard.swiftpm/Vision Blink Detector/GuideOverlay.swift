//
//  GuideOverlay.swift
//
//
//  Created with love and passion by Bertan
//
// Used in the GuidedVisionBlinkDetector, this view will overlay the camera feed to provide instruction

import SwiftUI

struct GuideOverlay<Content: View>: View {
    private let text: String
    private let systemImage: String?
    private let view: Content?

    init(_ text: String, systemImage: String? = nil) {
        self.text = text
        self.systemImage = systemImage
        self.view = nil
    }

    init(_ text: String, @ViewBuilder view: @escaping () -> Content) {
        self.text = text
        self.systemImage = nil
        self.view = view()
    }

    var body: some View {
        VStack {
            Spacer()
            Group {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .resizable()
                } else if let view = view {
                    view
                }
            }
            .scaledToFit()
            .frame(width: 80)
            .foregroundStyle(.white)
            .padding()

            Text(text)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
            Spacer()
            Spacer()
        }
        .roundedFont(.title2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Dim the background to stand out!
        .background(
            Color(.displayP3, red: 0, green: 0, blue: 0, opacity: 0.5)
        )
    }
}
