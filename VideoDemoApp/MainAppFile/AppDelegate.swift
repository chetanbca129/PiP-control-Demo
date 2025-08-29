//
//  AppDelegate.swift
//  VideoDemoApp
//
//  Created by 3H5T1N on 28/08/25.
//

import UIKit
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        // ✅ Required for PiP (background playback)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            try audioSession.setActive(true, options: [])
        } catch {
            print("⚠️ AVAudioSession setup failed: \(error.localizedDescription)")
        }

        return true
    }
}
