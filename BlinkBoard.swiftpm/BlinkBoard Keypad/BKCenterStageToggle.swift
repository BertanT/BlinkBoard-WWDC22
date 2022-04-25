//
//  BKCenterStageToggle.swift
//
//
//  Created with love and passion by Bertan
//
// SwiftUI view for the Center Stage toggle button in BlinkBoard Keypad

import SwiftUI

struct BKCenterStageToggle: View {
    // Uses EnvironmentObject to match the user selected accent color
    @EnvironmentObject private var model: BKViewModel
    @Binding var isOn: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
                .bkButtonBackground(keySize: 3)
            Toggle("Center\nStage", isOn: $isOn)
                .tint(Color(uiColor: model.accentColor))
                .font(.system(size: 18, design: .rounded))
                .frame(width: 126)
                .scaleEffect(0.9)
        }
    }
}
