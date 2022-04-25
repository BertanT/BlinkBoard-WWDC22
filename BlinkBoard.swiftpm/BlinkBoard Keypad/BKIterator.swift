//
//  BKIterator.swift
//  
//
//  Created with love and passion by Bertan
//
// AccessibilityIterator specialized for BlinkBoard Keypad that implements the BKViewModel!

import SwiftUI

struct BKIterator: View {
    // EnvironmentObject is used to:
    //  * Adopt user selected iterator gradient
    //  * Share the currently selected item's attributes with other views
    //  * Enable/disable the iterator with the mainKeypadCurrentIterator property of BKViewModel
    @EnvironmentObject private var model: BKViewModel

    @State private var isIterating: Bool = false

    private var items: [AIItem]
    // Every BKIterator has an id of enum type BKIteratorID
    // This is used to enable/disable the iterators easily by setting the mainKeypadCurrentIterator value in BKViewModel
    private let iteratorID: BKIteratorID
    private let orientation: AIOrientation

    init(items: [AIItem], iteratorID: BKIteratorID, orientation: AIOrientation = .horizontal) {
        self.items = items
        self.iteratorID = iteratorID
        self.orientation = orientation
    }

    var body: some View {
        AccessibilityIterator(items: items,
                              selectedItemAttributes: $model.mainKeypadSelectedItemAttributes, orientation: orientation,
                              gradient: model.iteratorGradient.gradientValue(),
                              isIterating: $isIterating)
        .onAppear {
            updateIterationState(newIteratorID: model.mainKeypadCurrentIterator)
        }
        .onChange(of: model.mainKeypadCurrentIterator, perform: updateIterationState)
    }

    // Method that compares the current iterator id and toggles the iterator accordingly
    private func updateIterationState(newIteratorID: BKIteratorID?) {
        isIterating = (iteratorID == newIteratorID)
    }
}
