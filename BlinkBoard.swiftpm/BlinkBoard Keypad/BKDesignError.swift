//
//  BKDesignError.swift
//  
//
//  Created with love and passion by Bertan
//
// Localized error enum for decoding errors in BlinkBoardDesign.json

import Foundation

enum BKDesignError: LocalizedError {
    case jsonMissing, invalidJSON

    var errorDescription: String? {
        switch self {
        case .jsonMissing:
            return "No keypad design JSON found in source!"
        case .invalidJSON:
            return "JSON file provided has syntax error!"
        }
    }
}
