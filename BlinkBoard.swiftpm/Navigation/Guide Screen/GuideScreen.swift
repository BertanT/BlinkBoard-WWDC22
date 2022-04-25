//
//  GuideScreen.swift
//
//
//  Created with love and passion by Bertan
//
// Onboarding page with usage instructions

import SwiftUI

struct GuideScreen: View {

    init() { }

    var body: some View {
        VStack {
            GradientLabel("Getting Started", systemImage: "text.book.closed.fill",
                          gradient: .purpleGradient, font: .largeTitle, weight: .medium)
            .padding(.top)
            .padding(.bottom, 0.5)
            Text("Learn How to Use BlinkBoard in 4 Steps")
                .roundedFont(.title2)
                .padding(10)
            VStack(alignment: .leading) {
                GuideItem(title: "Get In the Frame", systemImage: "person.fill.viewfinder", descriptionText: Text("""
                    Your whole face should be visible with no obstructions to your device's front-facing camera with\
                     good lighting, and no other face other than yours should be inside the frame. On supported\
                     devices, you can also toggle Center Stage from the keyboard!
                    """))
                GuideItem(title: "Find Your Character", systemImage: "character.cursor.ibeam", descriptionText: Text("""
                    The keyboard features an intuitive QWERTY-based layout optimized for BlinkBoard so you can find\
                     the letter you want to type almost instantly. Don't blink while looking for a character, though. 😄
                    """))
                GuideItem(title: "Blink and Type", systemImage: "eyes", descriptionText: Text("""
                    The keyboard will continuously skim through each row by highlighting them at an interval. Blink\
                     when the row containing your key gets highlighted to select it. The row will split into sections,\
                     and now the keyboard will skim through those. Blink again when the segment containing your key\
                     gets highlighted - the keyboard will scan through each key inside. Finally, blink when your\
                     character gets highlighted to type!

                    As you type, BlinkBoard will predict the word you want to write and show suggestions next to the\
                     text field. Use the \(Image(systemName: "wand.and.stars")) key to select one of them and speed up\
                     your typing process.

                    Action keys like \(Image(systemName: "wand.and.stars")) are located directly inside the rows so\
                     that you can access them quickly. Additionally, you can long blink for 1s to go back to the\
                     start if you make a mistake, while long-blinking at the top level will pause the keyboard when\
                     you need a break.
                    """))
                GuideItem(title: "Let The World Hear!", systemImage: "text.bubble", descriptionText: Text("""
                    After you finish typing, use the speak function to read your text out loud or the copy function\
                     to copy it onto the system clipboard.
                    """))
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
            GradientLabel("Long-blink to continue", systemImage: "chevron.forward", gradient: .lilacGradient)
                .padding(.bottom, 30)
        }
        .padding(.horizontal, 10)
    }
}
