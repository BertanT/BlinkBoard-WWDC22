//
//  GuideItem.swift
//
//
//  Created with love and passion by Bertan
//
// Instruction view used in GuideScreen

import SwiftUI

struct GuideItem: View {
    private let title: String
    private let systemImage: String
    private let descriptionText: Text

    private let screenHeight: CGFloat

    init(title: String, systemImage: String, descriptionText: Text) {
        self.title = title
        self.systemImage = systemImage
        self.descriptionText = descriptionText

        self.screenHeight = UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Use bigger symbols for the 12 inch iPad Pro!
            GradientLabel(title, systemImage: systemImage, gradient: .indigoGradient,
                          font: screenHeight >= 1000 ? .title1 : .title2)
            descriptionText
                .font(.system(size: UIScreen.main.adaptiveParagraphFontSize(), design: .rounded))
                .padding(.leading, 6)
        }
        .padding(.vertical, 3)
    }
}
