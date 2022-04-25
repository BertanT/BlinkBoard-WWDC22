//
//  BKDesign.swift
//
//
//  Created with love and passion by Bertan
//
// JSON decoding model to for BlinkBoardDesign.json file in the Bundle
// Allows for seamless localization of the keyboard for any language!

import SwiftUI

struct BKDesign: Decodable {
    // String arrays that make up the character keys in each row
    // The String values will be directly be typed onto the text field, so you can easily customize it
    // You can even add emoji keys to your liking!
    // These rows should only contain  character keys
    var rowOne: [String]
    var rowTwo: [String]
    var rowThree: [String]
    var rowFour: [String]

    // Action keys, unlike character keys, cannot be added or removed
    // However, their display names are customizable in JSON and the values are below
    var spaceKeyTitle: String
    var backspaceKeyTitle: String
    var clearKeyTitle: String
    var speakKeyTitle: String
    var copyKeyTitle: String
    var aboutKeyTitle: String

    // This will be used to set predictive text and text to speech language
    // Must be provided in BCP 47 Language Tag format!
    var languageTag: String

    // Method to get a 3D array of AIItem typed BlinkBoard Keypad items excluding action buttons!
    // Each array of AIItem represent one half row's items, ordered from left to right and top the bottom
    // Ex: To get the first item of the second row, you would need to call getCharItems()[2][0]
    func getCharItems() -> [[AIItem]] {
        var inputRowsData = [[String]]()

        inputRowsData.append(contentsOf: rowOne.splitInHalf() +
                             rowTwo.splitInHalf() + rowThree.splitInHalf() + rowFour.splitInHalf())

        var items = [[AIItem]]()

        inputRowsData.indices.forEach { index in
            items.append([AIItem]())
            inputRowsData[index].forEach { data in
                items[index].append(.init(keyChar: data))
            }
        }
        return items
    }
}
