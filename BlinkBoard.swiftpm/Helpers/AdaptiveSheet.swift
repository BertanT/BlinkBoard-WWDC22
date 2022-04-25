//
//  AdaptiveSheet.swift
//  
//
//  Created with love and passion by Bertan
//
// A custom sheet view that takes up a little less than full screen

import SwiftUI

private struct AdaptiveSheet<SheetContent: View>: ViewModifier {
    @Binding private var isPresented: Bool

    @State private var showingSheet: Bool
    @State private var showingBackground: Bool

    private let sheetContent: SheetContent

    init(isPresented: Binding<Bool>, @ViewBuilder sheetContent: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self._showingSheet = State(initialValue: isPresented.wrappedValue)
        self._showingBackground = State(initialValue: isPresented.wrappedValue)
        self.sheetContent = sheetContent()
    }

    func body(content: Content) -> some View {
        GeometryReader { geoReader in
            ZStack {
                content
                    .zIndex(0)
                if showingBackground {
                    // Darken the background when visible
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .zIndex(1)
                        .transition(.opacity)
                        .animation(.spring(), value: isPresented)
                }

                if showingSheet {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.background)
                            .shadow(radius: 20)
                        sheetContent
                    }
                    .frame(width: geoReader.size.width - 45,
                           height: geoReader.size.height - 45)
                    .zIndex(2)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: isPresented)
                    // Gesture to dismiss the sheet
                    // Will most probably not used in this app, but adding it for completeness
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded(handleGesture))
                }
            }
            .onChange(of: isPresented, perform: setPresentation)
        }
    }

    // Show the sheet and background with animation
    private func setPresentation(_ isPresented: Bool) {
        withAnimation {
            showingSheet = isPresented
            showingBackground = isPresented
        }
    }

    // Dismiss the sheet if the drag gesture height was more than 20 points
    private func handleGesture(_ value: DragGesture.Value) {
        if value.translation.height > 20 {
            setPresentation(false)
            isPresented = false
        }

    }
}

// Cleaner implementation of the modifier with View extension
extension View {
    func adaptiveSheet<Content: View>(isPresented: Binding<Bool>,
                                      @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(AdaptiveSheet(isPresented: isPresented, sheetContent: content))
    }
}
