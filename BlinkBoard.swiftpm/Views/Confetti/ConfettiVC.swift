//
//  ConfettiVC.swift
//  
//
//  Created with love and passion by Bertan
//
// A transparent UIKit ViewController to add confetti to any view!

import UIKit

final class ConfettiVC: UIViewController {
    // Delegate property, check ConfettiVCDelegate.swift for more!
    var delegate: ConfettiVCDelegate?
    // Property to hold the amount of confetti to be emitted
    var amount: Float
    // Property to hold all the different colors of confetti pieces
    var colors: [UIColor]

    private lazy var emitterLayers = [CAEmitterLayer]()
    private var sublayerRemovalTimer: Timer?

    init(amount: Float = 10, colors: [UIColor] = [.systemYellow, .systemMint, .systemIndigo, .systemPink]) {
        self.amount = amount
        self.colors = colors

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, renamed: "init(product:coder:)")
    required  init?(coder: NSCoder) {
        fatalError("Invalid attempt to decode the class ConfettiVC")
    }

    // Method to create an emitter cell for all of your confetti
    private func makeConfettiCell(with contentImage: UIImage) -> CAEmitterCell {
        let confettiCell = CAEmitterCell()

        // Play with this to customize!
        confettiCell.contents = contentImage.cgImage

        confettiCell.birthRate = 1
        confettiCell.lifetime = 10

        confettiCell.emissionLongitude = 1
        confettiCell.emissionRange = .pi / 8

        confettiCell.spin = 4
        confettiCell.spinRange = 8

        confettiCell.yAcceleration = 150
        confettiCell.velocityRange = 100

        return confettiCell
    }

    // A method that creates confetti an emitter cell for each color provided!
    private func makeConfettiCells() -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()

        // Generate a confetti piece image for each color and...
        ConfettiPieceGenerator().makeConfettiImages(colors: colors).forEach { image in
            // Create a confetti cell with that image and add it to the output array
            let confettiCell = makeConfettiCell(with: image)
            cells.append(confettiCell)
        }

        return cells
    }

    // Method to create an emitter layer for all the confetti cells
    private func makeEmitterLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()

        emitterLayer.emitterCells = makeConfettiCells()

        emitterLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 500)
        // Making sure the emitter layer is nicely centered
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.minY - 500)
        emitterLayer.frame = view.bounds

        emitterLayer.emitterShape = .rectangle

        // Setting these to zero now as we will fire the confetti in a different method!
        emitterLayer.birthRate = 0
        emitterLayer.beginTime = 0

        return emitterLayer
    }

    // Method to create a background emitter layer with semi-transparent, smaller and less confetti pieces
    // This gives it a nice 3D effect!
    private func makeBackgroundLayer() -> CAEmitterLayer {
        // Create a standard emitter layer using the above method - we'll convert to a background one!
        let backgroundLayer = makeEmitterLayer()

        // Make the background pieces 50% opaques, fall a little slower and scale them down a bit
        backgroundLayer.opacity = 0.5
        backgroundLayer.speed = 0.95

        backgroundLayer.emitterCells?.forEach { cell in
            cell.scale = 0.5
        }

        return backgroundLayer
    }

    // Private method used to stop emission!
    private func stopEmission() {
        emitterLayers.forEach { layer in
            layer.birthRate = 0
        }
    }

    // This is where the action is! This method starts emission in all the emitter layers we have
    func popConfetti() {
        // Stop any previous emissions to prevent overlap
        stopEmission()
        sublayerRemovalTimer?.invalidate()

        // Crete new layers, and start emission in each one
        let layers = [makeEmitterLayer(), makeBackgroundLayer()]
        layers.forEach { layer in
            layer.beginTime = CACurrentMediaTime()
            layer.birthRate = amount
            // Putting them in our property so we can access them elsewhere in the class
            emitterLayers.append(layer)
            self.view.layer.addSublayer(layer)
        }

        // Call delegate method
        delegate?.onEmittingStateChange(true)
    }

    func stopConfetti() {
        // Stop the emitters
        stopEmission()
        // We need to wait a little before removing the sublayers since the already on screen confetti take
        // a few seconds to fall down and get out of the screen. Otherwise all the confetti onscreen suddenly disappear
        self.sublayerRemovalTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.view.layer.sublayers?.removeAll()
        }

        // Delegate method!
        delegate?.onEmittingStateChange(false)
    }
}
