//
//  TextToSpeechEngine.swift
//
//
//  Created with love and passion by Bertan
//
// A simple and clean implementation of AVSpeechSynthesizer

import AVFAudio
import SwiftUI

final class TextToSpeechEngine: NSObject, ObservableObject {
    @Published  private(set) var isSpeaking = false

    private let synth = AVSpeechSynthesizer()

    override init() {
        super.init()
        self.synth.delegate = self
    }

    func speak(_ text: String, language: String?) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        synth.speak(utterance)
    }

    func stopSpeaking(at boundary: AVSpeechBoundary = .immediate) {
        self.synth.stopSpeaking(at: boundary)
    }
}

extension TextToSpeechEngine: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        withAnimation {
            isSpeaking = true
        }
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        withAnimation {
            isSpeaking = true
        }
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        withAnimation {
            isSpeaking = false
        }
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        withAnimation {
            isSpeaking = false
        }
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        withAnimation {
            isSpeaking = false
        }
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
