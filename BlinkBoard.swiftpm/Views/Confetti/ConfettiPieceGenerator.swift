//
//  ConfettiPieceGenerator.swift
//  
//
//  Created with love and passion by Bertan
//
// A class that creates colored rectangle and circle images in the UIImage type
// These images are used as emitter cell contents in ConfettiVC

import UIKit

final class ConfettiPieceGenerator {
    // Get CGRect for the specified confetti shape type - see ConfettiShape.swift for more
    private func getConfettiImageRect(for shape: ConfettiShape) -> CGRect {
        switch shape {
        case .rectangle:
            return CGRect(x: 0, y: 0, width: 20, height: 13)
        case .circle:
            return CGRect(x: 0, y: 0, width: 10, height: 10)
        }
    }

    // Method to make a single confetti image in the UIImage type with a given confetti shape type and color
    private func makeConfettiImage(shape: ConfettiShape, color: UIColor) -> UIImage {
        let imageRect = getConfettiImageRect(for: shape)

        UIGraphicsBeginImageContext(imageRect.size)
        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)

        switch shape {
        case .rectangle:
            context.fill(imageRect)
        case .circle:
            context.fillEllipse(in: imageRect)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()!

        return image
    }

    // Method to make confetti images for each shape style with a given color
    func makeConfettiImages(colors: [UIColor]) -> [UIImage] {
        var images = [UIImage]()

        colors.forEach { color in
            ConfettiShape.allCases.forEach { shape in
                images.append(makeConfettiImage(shape: shape, color: color))
            }
        }

        return images
    }
}
