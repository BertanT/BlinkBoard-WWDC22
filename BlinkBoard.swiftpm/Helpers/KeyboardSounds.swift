//
//  KeyboardSounds.swift
//
//
//  Created with love and passion by Bertan
//
// Simple class for playing keyboard sounds cleanly

import AVKit

struct KeyboardSounds {
    init() { }

    func playDefaultClick() {
        AudioServicesPlaySystemSound(1104)
    }

    func playModifierClick() {
        AudioServicesPlaySystemSound(1156)
    }

    func playDeleteClick() {
        AudioServicesPlaySystemSound(1155)
    }

    func playActivationSound() {
        AudioServicesPlaySystemSound(1109)
    }
}
