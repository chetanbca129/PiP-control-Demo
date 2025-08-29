//
//  VideoPlayerContainerView.swift
//  VideoDemoApp
//
//  Created by 3H5T1N on 28/08/25.
//

import SwiftUI
import AVKit

// MARK: - SwiftUI Wrapper
struct VideoPlayerContainerView: UIViewControllerRepresentable {
    let url: URL
    @Binding var coordinatorRef: VideoPlayerContainerView.Coordinator? // expose coordinator to toggle PiP

    func makeCoordinator() -> Coordinator {
        let c = Coordinator(url: url)
        DispatchQueue.main.async { self.coordinatorRef = c } // expose it once created
        return c
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return context.coordinator.playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // no-op
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject, AVPlayerViewControllerDelegate, AVPictureInPictureControllerDelegate {
        let player: AVPlayer
        let playerLayer: AVPlayerLayer
        let playerViewController: AVPlayerViewController

        private var pipController: AVPictureInPictureController?
        private var timeControlObservation: NSKeyValueObservation?
        private var pipPossibleObservation: NSKeyValueObservation?
        private var hostView: PlayerHostView?

        init(url: URL) {
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: player)
            self.playerViewController = AVPlayerViewController()
            super.init()
            configurePlayerVC()
            attachLayerHost()
            observePlayerStart()
            player.play()
        }

        deinit {
            timeControlObservation?.invalidate()
            pipPossibleObservation?.invalidate()
        }

        private func configurePlayerVC() {
            playerViewController.player = player
            playerViewController.delegate = self
            playerViewController.allowsPictureInPicturePlayback = true
            // optional: allow auto-start from inline
            playerViewController.canStartPictureInPictureAutomaticallyFromInline = true
        }

        private func attachLayerHost() {
            // create host view that keeps the playerLayer in the view hierarchy and resizes it
            let host = PlayerHostView(playerLayer: playerLayer)
            host.translatesAutoresizingMaskIntoConstraints = false
            self.hostView = host

            // Add the host into contentOverlayView (safe place to put custom overlays)
            // contentOverlayView is available on AVPlayerViewController
            if let overlay = playerViewController.contentOverlayView {
                overlay.addSubview(host)
                NSLayoutConstraint.activate([
                    host.leadingAnchor.constraint(equalTo: overlay.leadingAnchor),
                    host.trailingAnchor.constraint(equalTo: overlay.trailingAnchor),
                    host.topAnchor.constraint(equalTo: overlay.topAnchor),
                    host.bottomAnchor.constraint(equalTo: overlay.bottomAnchor)
                ])
            } else {
                // fallback: add to main view
                playerViewController.view.addSubview(host)
                NSLayoutConstraint.activate([
                    host.leadingAnchor.constraint(equalTo: playerViewController.view.leadingAnchor),
                    host.trailingAnchor.constraint(equalTo: playerViewController.view.trailingAnchor),
                    host.topAnchor.constraint(equalTo: playerViewController.view.topAnchor),
                    host.bottomAnchor.constraint(equalTo: playerViewController.view.bottomAnchor)
                ])
            }
        }

        private func observePlayerStart() {
            // when the player starts playing, attempt to create PiP controller (playerLayer must be in view hierarchy)
            timeControlObservation = player.observe(\.timeControlStatus, options: [.initial, .new]) { [weak self] player, change in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if player.timeControlStatus == .playing {
                        self.createPiPIfNeeded()
                    }
                }
            }
        }

        private func createPiPIfNeeded() {
            guard pipController == nil else { return } // already prepared
            guard AVPictureInPictureController.isPictureInPictureSupported() else {
                print("❌ PiP not supported on this device")
                return
            }

            // Use the playerLayer initializer (widely available)
            if let pip = AVPictureInPictureController(playerLayer: playerLayer) {
                pip.delegate = self
                pipController = pip

                pipPossibleObservation = pip.observe(\AVPictureInPictureController.isPictureInPicturePossible, options: [.initial, .new]) { pip, change in
                    DispatchQueue.main.async {
                        print("ℹ️ PiP possible: \(pip.isPictureInPicturePossible)")
                    }
                }

                print("ℹ️ PiP controller created — waiting for isPictureInPicturePossible = true")
            } else {
                print("⚠️ Failed to create AVPictureInPictureController with playerLayer")
            }
        }

        // MARK: - Public API
        func togglePiP() {
            guard let pip = pipController else {
                print("⚠️ PiP controller not ready yet.")
                return
            }

            if pip.isPictureInPictureActive {
                pip.stopPictureInPicture()
            } else if pip.isPictureInPicturePossible {
                pip.startPictureInPicture()
            } else {
                print("⚠️ PiP not possible yet (isPictureInPicturePossible == false).")
            }
        }

        // Optional: attempt to auto-start PiP when app goes to background
        func tryStartPiPOnBackground() {
            guard let pip = pipController, pip.isPictureInPicturePossible, !pip.isPictureInPictureActive else { return }
            pip.startPictureInPicture()
        }

        // MARK: - AVPictureInPictureControllerDelegate
        func pictureInPictureControllerDidStartPictureInPicture(_ controller: AVPictureInPictureController) {
            print("✅ PiP started")
        }

        func pictureInPictureControllerDidStopPictureInPicture(_ controller: AVPictureInPictureController) {
            print("🛑 PiP stopped")
        }

        func pictureInPictureController(_ controller: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
            print("❌ PiP failed to start: \(error.localizedDescription)")
        }

        func pictureInPictureControllerRestoreUserInterfaceForPictureInPictureStop(_ controller: AVPictureInPictureController,
                                                                                   completionHandler: @escaping (Bool) -> Void) {
            // bring UI back if needed
            completionHandler(true)
        }
    }
}



