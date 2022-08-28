//
//  HapticsEngine.swift
//  HapticStopwatch WatchKit Extension
//
//  Created by Josh Heslin on 28/8/2022.
//

import Foundation
import SwiftUI

class HapticsEngine: NSObject, ObservableObject {
    static let shared = HapticsEngine()

    private var timer: Timer?
    private var session = WKExtendedRuntimeSession()

    private var isPlaying: Bool { timer != nil }
    
    var intervalValue: Int = 1
    @Published var historyString: String = ""
    @Published var timerValue: Int = 1

    private func startSessionIfNeeded() {
        guard !isPlaying, session.state != .running else { return }

        session = WKExtendedRuntimeSession()
        session.start()
    }

    private func stopSession() {
        session.invalidate()
    }
    
    var minutes: Int {
        (self.timerValue % 3600) / 60
    }

    var seconds: Int {
        self.timerValue % 60
    }

    private func tick() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] (_) in

            self?.tick()
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self?.timerValue += 1
            }
            
            print("\(String(describing: self?.timerValue)) / \(String(describing: self?.intervalValue))")
            
            if let timerSeconds = self?.timerValue {
                if let intervalSeconds = self?.intervalValue {
                    if ((timerSeconds % intervalSeconds) == 0) {
                        if timerSeconds != 0 {
                            print("buzz")
                            WKInterfaceDevice.current().play(.success)
                            self?.historyString += "*"
                        }
                    }
                }
            }
        })
    }

    func startPlayingTicks(intervalVal: Int) {
        timer?.invalidate()
        timer = nil
        timerValue = 0
        historyString = ""
        
        intervalValue = intervalVal

        startSessionIfNeeded()
        WKInterfaceDevice.current().play(.start)

        tick()
    }

    func stopPlayingTicks() {
        timer?.invalidate()
        timer = nil
        timerValue = 0

        stopSession()
    }
}
