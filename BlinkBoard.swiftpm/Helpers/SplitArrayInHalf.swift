//
//  SplitArrayInHalf.swift
//
//
//  Created with love and passion by Bertan
//
// Array extension to split any given array into half
// Even ones with an odd number of elements

extension Array {
    func splitInHalf() -> [[Element]] {
        let chunkSize = Int((Float(self.count) / 2.0).rounded(.up))
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
