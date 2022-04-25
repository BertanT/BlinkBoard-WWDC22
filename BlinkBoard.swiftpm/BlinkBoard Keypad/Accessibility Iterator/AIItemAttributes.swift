//
//  AIItemAttributes.swift
//  
//
//  Created with love and passion by Bertan
//
// Attribute type used in AIItem!

struct AIItemAttributes {
    // If this is a letter key used in the keyboard, it will type the string inside KeyText
    var keyText: String?
    // This key will execute any action provided in this closure when pressed
    var action: (() -> Void)?
}
