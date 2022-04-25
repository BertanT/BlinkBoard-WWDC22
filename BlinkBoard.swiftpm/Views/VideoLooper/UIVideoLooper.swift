//
//  UIVideoLooper.swift
//  
//
//  Created with love and passion by Bertan
//
// UIKit View that loops a given video forever without audio

import UIKit
import AVKit

class UIVideoLooper: UIView {
    var videoURL: URL {
        willSet {
            if newValue != videoURL && self.queuePlayer?.timeControlStatus == .playing {
                stopVideo()
                playVideo(videoURL: newValue)
            }
        }
    }
    private var isPlaying = false
    private var looper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    private var playerLayer: AVPlayerLayer?

    init(frame: CGRect = .zero, videoURL: URL) {
        self.videoURL = videoURL
        super.init(frame: frame)
    }

    @available(*, unavailable, renamed: "init(product:coder:)")
    required  init?(coder: NSCoder) {
        fatalError("Invalid attempt to decode the class UIPlayerView")
    }

    private func playVideo(videoURL: URL) {
        playerLayer = AVPlayerLayer()
        queuePlayer = AVQueuePlayer()

        let asset = AVAsset(url: videoURL)
        let item = AVPlayerItem(asset: asset)

        playerLayer!.player = queuePlayer
        // Remove the following line if you want audio!
        playerLayer!.player?.isMuted = true

        layer.sublayers?.removeAll()
        layer.addSublayer(playerLayer!)

        looper = AVPlayerLooper(player: queuePlayer!, templateItem: item)

        // Prevent the VideoLooper to from interrupting your music :)
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)

        queuePlayer?.play()

        isPlaying = true
    }

    private func stopVideo() {
        self.queuePlayer?.pause()

        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.queuePlayer = nil
        self.looper = nil

        isPlaying = false
    }

    // Easy to use control method to be used outside the class
    func control(isPlaying: Bool) {
        // Don't do anything if the current state is the same as the requested state
        if self.isPlaying == isPlaying {
            return
        }
        if isPlaying {
            playVideo(videoURL: videoURL)
        } else {
            stopVideo()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
