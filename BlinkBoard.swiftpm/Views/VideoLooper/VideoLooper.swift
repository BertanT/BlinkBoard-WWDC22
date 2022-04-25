//
//  VideoLooper.swift
//  
//
//  Created with love and passion by Bertan
//
// Porting UIVideoLooper to SwiftUI!

import SwiftUI

struct VideoLooper: UIViewRepresentable {
    private(set) var videoURL: URL
    private(set) var isPlaying: Bool

    init(videoURL: URL, isPLaying: Bool) {
        self.videoURL = videoURL
        self.isPlaying = isPLaying
    }

    func makeUIView(context: Context) -> UIVideoLooper {
        let playerView = UIVideoLooper(videoURL: videoURL)
        return playerView
    }

    func updateUIView(_ uiVideoLooper: UIVideoLooper, context: Context) {
        uiVideoLooper.videoURL = videoURL
        uiVideoLooper.control(isPlaying: isPlaying)
    }
}
