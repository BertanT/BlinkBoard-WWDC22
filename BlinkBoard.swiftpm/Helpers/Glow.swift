//
//  Glow.swift
//
//
//  Created with love and passion by Bertan
//
//  A custom colorful glow modifier!

import SwiftUI

extension View {
    func glow(radius: CGFloat = 15) -> some View {
        ZStack {
            // Don't add an overlay if the radius is set to 0, it can look weird
            if radius != 0 {
                self.overlay(self.blur(radius: radius)).opacity(0.5)
            }
            self
        }
    }
}
