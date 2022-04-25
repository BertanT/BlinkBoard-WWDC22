//
//  WordPredictorItem.swift
//
//
//  Created with love and passion by Bertan
//
// SwiftUI View that make up each prediction in WordPredictor

import SwiftUI

struct WordPredictorItem: View {
    let prediction: String

    init(_ prediction: String) {
        self.prediction = prediction
    }

    var body: some View {
        Text(prediction)
            .roundedFont(.body)
            .transition(.move(edge: .trailing))
            .animation(.interactiveSpring(), value: prediction)
            .padding(14)
    }
}
