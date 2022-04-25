//
//  BKMode.swift
//
//
//  Created with love and passion by Bertan
//
// Enum used to set BlinkBoard Keypad mode

enum BKMode {
    case active, // Activated and the user is typing
         speaking, // Text to speech in progress
         paused, // Paused and resumable by user
         stopped // Stopped by the app, user cannot resume
}
