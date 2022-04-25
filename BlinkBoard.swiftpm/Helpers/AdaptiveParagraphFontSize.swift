//
//  AdaptiveParagraphFontSize.swift
//
//
//  Created with love and passion by Bertan
//
// A font size that adapts according to the current screen size, ideal for long text!

import UIKit

extension UIScreen {
    func adaptiveParagraphFontSize() -> CGFloat {
        let screenHeight = self.nativeBounds.width / UIScreen.main.nativeScale
        // iPad Pro 12.9", iPad Pro/Air 11", iPad 10", iPad 9.7"
        if screenHeight >= 1000 {
            return 22
        } else if screenHeight >= 830 {
            return 20
        } else if screenHeight >= 810 {
            return 18
        } else {
            return 16.5
        }
    }
}
