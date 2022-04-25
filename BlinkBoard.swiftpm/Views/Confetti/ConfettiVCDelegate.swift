//
//  ConfettiVCDelegate.swift
//  
//
//  Created with love and passion by Bertan
//
// UIKit delegate protocol to handle confetti start and stop in ConfettiVC

protocol ConfettiVCDelegate: AnyObject {
    func onEmittingStateChange(_ newState: Bool)
}

extension ConfettiVCDelegate {
    func onEmittingStateChange(_ newState: Bool) { }
}
