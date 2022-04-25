//
//  VisionBlinkDetectorVCDelegate.swift
//
//
//  Created with love and passion by Bertan
//
// UIKit delegate protocol to hold shared VisionBlinkDetector data

protocol VisionBlinkDetectorVCDelegate: AnyObject {
    // The current detected blink state
    var detectedState: VBDState { get set }
    // Runs when the camera initialization is complete, returning any errors inside the closure
    var onCamInitComplete: (VBDError?) -> Void { get set }
}
