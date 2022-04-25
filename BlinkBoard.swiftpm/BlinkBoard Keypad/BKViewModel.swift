//
//  BKViewModel.swift
//  
//
//  Created with love and passion by Bertan
//
// SwiftUI ObservableObject view model that holds various shared data inside the app

import SwiftUI

final class BKViewModel: ObservableObject {

    init() {
        updateAccentColor()
    }

    // Text typed by the user
    @Published  var text = "" {
        willSet {
            // Update text predictions when the user types
            guard let lastWord = text.components(separatedBy: .whitespacesAndNewlines).last else { return }
            let checker = UITextChecker()
            let predictions = checker.completions(forPartialWordRange: NSRange(0..<lastWord.count),
                                                  in: lastWord, language: language)
            let limitedPredictions = predictions?.prefix(3)
            textPredictions = Array(limitedPredictions ?? [])
        }
    }
    // Language tag for text to speech and predictive text,
    // default value is replaced by the value in BlinkBoardDesign.json
    @Published var language = "en-US"
    // Array of words predictions, updated as the user types
    @Published private(set) var textPredictions = [String]()
    @Published private(set) var mainKeypadMode: BKMode = .stopped
    @Published var blinkState: VBDState = .noFaces
    // Property that holds the id of the currently active iterator
    @Published private(set) var mainKeypadCurrentIterator: BKIteratorID?
    // Property that holds the attributes of the currently highlighted item
    @Published var mainKeypadSelectedItemAttributes: AIItemAttributes?
    // Property that holds the user selected highlight gradient
    @AppStorage("iteratorGradient")  var iteratorGradient: IteratorGradient = .moon {
        didSet {
            updateAccentColor()
        }
    }
    // Accent color that adapts according to the user selected highlight gradient
    @Published  private(set) var accentColor: UIColor = .systemGray

    // More menu sheet controls
    @Published  var showingIteratorGradientSheet = false
    @Published  var showingGuideSheet = false
    @Published  var showingAboutSheet = false

    // Method to set class properties with animation cleanly
    func setMainKeypadIterator(_ iterator: BKIteratorID?) {
        withAnimation {
            self.mainKeypadCurrentIterator = iterator
        }
    }

    func setMainKeypadMode(_ mode: BKMode) {
        withAnimation {
            self.mainKeypadMode = mode
        }
    }

    private func updateAccentColor() {
        withAnimation {
            accentColor = UIColor(iteratorGradient.gradientValue().stops.splitInHalf()[0].last!.color)
        }
    }
}
