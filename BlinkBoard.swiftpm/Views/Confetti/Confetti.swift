//
//  Confetti.swift
//  
//
//  Created with love and passion by Bertan
//
// Porting ConfettiVC to SwiftUI!

import SwiftUI

struct Confetti: UIViewControllerRepresentable {
    @Binding private var isEmitting: Bool

    private var amount: Float
    private var colors: [UIColor]

    init(isEmitting: Binding<Bool>, amount: Float = 10,
         colors: [UIColor] = [.systemYellow, .systemMint, .systemIndigo, .systemPink]) {
        self.amount = amount
        self.colors = colors
        self._isEmitting = isEmitting
    }

    class Coordinator: NSObject, ConfettiVCDelegate {
        var parent: Confetti

        init(_ parent: Confetti) {
            self.parent = parent
        }

        func onEmittingStateChange(_ newState: Bool) {
            DispatchQueue.main.async {
                self.parent.isEmitting = newState
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ConfettiVC {
        let confettiVC = ConfettiVC(colors: [.systemYellow, .systemPink, .systemIndigo])
        confettiVC.delegate = context.coordinator

        return confettiVC
    }

    func updateUIViewController(_ confettiVC: ConfettiVC, context: Context) {
        let oldAmount = confettiVC.amount
        let oldColors = confettiVC.colors

        // Only update if changes were made and is emitting!
        if (amount != oldAmount || colors != oldColors) && isEmitting {
            confettiVC.amount = amount
            confettiVC.colors = colors
            confettiVC.popConfetti()
        } else if isEmitting {
            confettiVC.popConfetti()
        } else {
            confettiVC.stopConfetti()
        }
    }
}
