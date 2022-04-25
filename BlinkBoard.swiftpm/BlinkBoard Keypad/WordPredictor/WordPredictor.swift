//
//  TextToSpeechEngine.swift
//
//
//  Created with love and passion by Bertan
//
// SwiftUI View used to choose from the predicted words and add them to the text
// Placed to the right side of the text field, and only visible when there are suggestions

import SwiftUI

struct WordPredictor: View {
    @EnvironmentObject private var model: BKViewModel
    @State private var predictorItems = [AIItem]()

    var body: some View {
        HStack {
            if !predictorItems.isEmpty {
                Divider()
                    .transition(.move(edge: .trailing))
                    .ignoresSafeArea()
                BKIterator(items: predictorItems, iteratorID: .wordPredictions)
                    .transition(.move(edge: .trailing))
                    .ignoresSafeArea()
                    .environmentObject(model)
            }
        }
        .onChange(of: model.textPredictions, perform: updateIterator)
    }

    // Method to update the iterator items when new suggestions are generated
    private func updateIterator(predictions: [String]) {
        var predictorItems = [AIItem]()
        predictions.forEach { prediction in
            predictorItems.append(AIItem(itemView: AnyView(
                WordPredictorItem(prediction)), action: {
                    // Every predictor item has an action that replaces the current word by itself
                    KeyboardSounds().playDefaultClick()
                    replaceTextWithPrediction(prediction: prediction)
                    model.setMainKeypadIterator(.main)
                }))
        }
        withAnimation {
            self.predictorItems = predictorItems
        }

    }

    // Method used to insert a selected prediction
    private func replaceTextWithPrediction(prediction: String) {
        guard let charCountToDrop = model.text.components(separatedBy: .whitespacesAndNewlines).last?.count else {
            return
        }
        model.text = String(model.text.dropLast(charCountToDrop)).appending(prediction)
    }
}
