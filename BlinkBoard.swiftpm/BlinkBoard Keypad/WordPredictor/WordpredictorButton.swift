//
//  WordPredictorButton.swift
//
//
//  Created with love and passion by Bertan
//
// SwiftUI View for the word predictor button which switches the iterator to WordPredictor

import SwiftUI

struct WordPredictorButton: View {
    @EnvironmentObject private var model: BKViewModel

    var body: some View {
        Image(systemName: "wand.and.stars")
        // Disable the button if there are no predictions!
            .foregroundStyle(model.textPredictions.isEmpty ? .secondary : .primary)
            .bkButtonBackground()
    }
}
