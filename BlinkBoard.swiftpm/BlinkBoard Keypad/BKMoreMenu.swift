//
//  BKMoreMenu.swift
//
//
//  Created with love and passion by Bertan
//
// BlinkBoard Keypad button with a popover menu containing an AccessibilityIterator user can use to choose extra options
// Options include: Changing highlight gradient, viewing user guide, and viewing about screen onboarding page

import SwiftUI

struct BKMoreMenu: View {
    @EnvironmentObject private var model: BKViewModel

    // State property to show/hide the popover
    @State private var isPresented: Bool = false

    @State private var menuItems: [AIItem]?

    // Property to hold if a sheet was opened by the user in order to prevent accidental main keypad activation on disappear
    @State private var openedSheet = false

    var body: some View {
        Image(systemName: "dock.arrow.up.rectangle")
            .font(.system(size: 20, design: .rounded))
            .bkButtonBackground()
            .drawingGroup()
            .popover(isPresented: $isPresented) {
                VStack {
                    if let menuItems = menuItems {
                        BKIterator(items: menuItems, iteratorID: .moreMenu)
                            .environmentObject(model)
                            .padding(.horizontal, 20)
                    }
                }
                .onDisappear(perform: handleCloseMenu)
                .handleBlinks(blinkState: model.blinkState, onBlink: handleBlink)
            }
            .onAppear(perform: menuSetup)
            .onChange(of: model.mainKeypadCurrentIterator, perform: handleIteratorChange)
    }

    // Method to the menu iterator items and assign them to self
    private func menuSetup() {
        let menuItems: [AIItem] = [
            AIItem(itemView: AnyView(BKButton("Customize", keySize: 4)), action: {
                model.showingIteratorGradientSheet = true
            }),
            AIItem(itemView: AnyView(BKButton("Guide", keySize: 2)), action: {
                model.showingGuideSheet = true
            }),
            AIItem(itemView: AnyView(BKButton("About", keySize: 2)), action: {
                model.showingAboutSheet = true
            })
        ]

        self.menuItems = menuItems
    }

    // Method to show the popover when the iterator is set to the more menu
    // and hide it if its visible and the current iterator is anything else
    private func handleIteratorChange(newIteratorID: BKIteratorID?) {
        if newIteratorID == .moreMenu {
            isPresented = true
        } else if isPresented {
            isPresented = false
        }
    }

    // Activate the keypad back again when the menu is closed without opening a sheet
    private func handleCloseMenu() {
        if openedSheet {
            // Reset the property for correct functioning
            openedSheet = false
            return
        }
        model.setMainKeypadIterator(.main)
    }

    // The blink action is executed inside BlinkBoardKeypad.swift
    // Some extra stuff are here!
    private func handleBlink() {
        KeyboardSounds().playModifierClick()
        openedSheet = true
        model.setMainKeypadMode(.stopped)
    }
}
