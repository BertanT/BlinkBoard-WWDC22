//
//  AccessibilityIterator.swift
//
//
//  Created with love and passion by Bertan
//
// This view is the base of BlinkBoard! It highlights the SwiftUI Views inside the AIItem type of objects
// passed into it in a set interval, and sets a binding property to contain attributes of the currently highlighted item

import Foundation
import SwiftUI

struct AccessibilityIterator: View {
    // Boolean to control the iteration
    @Binding private var isIterating: Bool
    // This property stores the attributes of the currently highlighted item
    // See AIItemAttributes.swift for more
    @Binding private var selectedItemAttributes: AIItemAttributes?

    @State private var highlightedIndex: Int?
    @State private(set) var maxIndex: Int

    // Timer that changes the highlighted item at an interval
    @State private var timer: Timer?

    // The array of items that'll be iterated through
    // Items contain the view and item attributes, see AIItem.swift for more
    private var items: [AIItem]

    // Some general options for the AccessibilityIterator
    private let iterationInterval: CGFloat
    private let orientation: AIOrientation
    private let gradient: Gradient

    init(items: [AIItem], selectedItemAttributes: Binding<AIItemAttributes?>, iterationInterval: CGFloat = 0.8,
         orientation: AIOrientation = .horizontal, gradient: Gradient, isIterating: Binding<Bool>) {
        self.items = items
        self._selectedItemAttributes = selectedItemAttributes

        self.iterationInterval = iterationInterval
        self.orientation = orientation
        self.gradient = gradient

        self._isIterating = isIterating

        self.maxIndex = items.count - 1
    }

    private var iterator: some View {
        Group {
            ForEach(items.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    items[index].itemView
                }
                .overlay {
                    if index == highlightedIndex {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(LinearGradient(gradient: gradient, startPoint: .topLeading,
                                                   endPoint: .bottomTrailing), lineWidth: 4)
                            .glow(radius: 8)
                            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                }
            }
        }
        // Start iterating on appear, and stop on disappear
        .onAppear {
            setIteration(enabled: isIterating)
        }
        .onDisappear {
            setIteration(enabled: false)
        }
        // Set iteration on binding change
        .onChange(of: isIterating) { isIterating in
            setIteration(enabled: isIterating)
        }
        // Automatically update the maximum index!
        .onChange(of: items.count) { newItemCount in
            self.maxIndex = newItemCount - 1
        }
    }

    var body: some View {
        if orientation == .horizontal {
            HStack(spacing: 0) {
                iterator
            }
        } else {
            VStack(spacing: 0) {
                iterator
            }
        }
    }

    // Method that advances to highlight the next item - run by timer
    private func iterationTimerAction(_ timer: Timer) {
        var next = (highlightedIndex ?? 0) + 1
        // If maximum index is exceeded, return back to the first one
        if next > maxIndex {
            next = 0
        }
        withAnimation {
            highlightedIndex = next
        }
        selectedItemAttributes = items[next].attributes
    }

    // Method that starts and stops the iterator
    private func setIteration(enabled: Bool) {
        if items.isEmpty {
            return
        }
        if timer?.isValid ?? false, enabled {
            return
        }

        if enabled {
            // Highlight the first item and set the timer to start
            highlightedIndex = 0
            selectedItemAttributes = items[0].attributes
            timer = Timer.scheduledTimer(withTimeInterval: iterationInterval,
                                         repeats: true, block: iterationTimerAction)
        } else {
            timer?.invalidate()
            highlightedIndex = nil
            //selectedItemAttributes = nil
        }
    }
}
