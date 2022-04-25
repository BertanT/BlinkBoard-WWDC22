//
//  SentenceCapitalized.swift
//
//
//  Created with love and passion by Bertan
//
// An extension to string that applies correct sentence capitalization
// Ex: "hello, world." -> "Hello, world."

extension String {
    func sentenceCapitalized() -> String {
        var capitalizedString = ""
        let stringRange = self.startIndex..<self.endIndex

        self.uppercased().enumerateSubstrings(in: stringRange, options: .bySentences) { substring, _, _, _ in
            capitalizedString.append(contentsOf: substring!.prefix(1))
            capitalizedString.append(contentsOf: substring!.dropFirst().lowercased())
        }

        return capitalizedString
    }
}
