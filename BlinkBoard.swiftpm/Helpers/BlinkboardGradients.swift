//
//  BlinkBoardGradients.swift
//
//
//  Created with love and passion by Bertan
//
// Predefining gradients used throughout the app to make code cleaner

import SwiftUI

// Colors used in the moonGradient
extension UIColor {
    static var metallicGray: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
            UIColor(red: 0.898, green: 0.898, blue: 0.918, alpha: 1) :
            UIColor(red: 0.173, green: 0.173, blue: 0.173, alpha: 1)
        }
    }

    static var metallicGray2: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
            UIColor(red: 0.820, green: 0.820, blue: 0.918, alpha: 1) :
            UIColor(red: 0.227, green: 0.227, blue: 0.235, alpha: 1)
        }
    }
}

extension Gradient {
    // Some hand dandy predefined gradients
    static var moonGradient = Gradient(colors: [.metallicGray, .metallicGray2].map { Color($0) })
    static var breezeGradient = Gradient(colors: [UIColor.systemMint, UIColor.systemGreen].map { Color($0) })
    static var indigoGradient = Gradient(colors: [UIColor.systemTeal, UIColor.systemIndigo].map { Color($0) })
    static var summerGradient = Gradient(colors: [UIColor.systemOrange, UIColor.systemPink].map { Color($0) })
    static var lilacGradient = Gradient(colors: [Color(UIColor.systemPurple), Color(UIColor.systemPink)])
    static var purpleGradient = Gradient(colors: [Color(UIColor.systemPurple), Color(UIColor.systemIndigo)])
    static var raspberryGradient = Gradient(colors: [UIColor.systemRed, UIColor.systemPink].map { Color($0) })

    // Some fancy,
    // Computed property,
    // Some Fruit Company,
    // Gradient out here.

    // Those colors... Seem familiar somehow
    static func sixColorGradient(colorRange: ClosedRange<Int>? = nil) -> Gradient {
        let sixColors = [UIColor](arrayLiteral:
                .systemGreen, .systemYellow, .systemOrange, .systemRed, .systemPurple, .systemBlue).map { Color($0) }

        if let range = colorRange,
           sixColors.indices.contains(range.lowerBound), sixColors.indices.contains(range.upperBound) {
            return Gradient(colors: Array(sixColors[range]))
        } else {
            return Gradient(colors: sixColors)
        }
    }
}
