//
//  IteratorGradient.swift
//
//
//  Created with love and passion by Bertan
//
// Enum containing iterator gradient options, as well as their display names as raw values

import SwiftUI

enum IteratorGradient: String, CaseIterable {
    case moon = "Moon"
    case breeze = "Breeze"
    case indigo = "Indigo"
    case summer  = "Summer"
    case lilac = "Lilac"
    case raspberry = "Raspberry"
    case rainbow = "Rainbow"

    func gradientValue() -> Gradient {
        switch self {
        case .moon:
            return Gradient.moonGradient
        case .breeze:
            return Gradient.breezeGradient
        case .indigo:
            return Gradient.indigoGradient
        case .summer:
            return Gradient.summerGradient
        case .lilac:
            return Gradient.lilacGradient
        case .raspberry:
            return Gradient.raspberryGradient
        case .rainbow:
            return Gradient.sixColorGradient()
        }
    }
}
