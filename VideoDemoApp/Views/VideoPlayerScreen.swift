//
//  VideoPlayerScreen.swift
//  VideoDemoApp
//
//  Created by 3H5T1N on 28/08/25.
//

import SwiftUI
import AVKit

struct VideoPlayerScreen: View {
    let video: VideoItem
    @State private var coordinator: VideoPlayerContainerView.Coordinator?

    var body: some View {
        VStack(spacing: 16) {
            VideoPlayerContainerView(url: video.url, coordinatorRef: $coordinator)
                // player UI will render; hostView ensures playerLayer exists for PiP
                .frame(height: 260)
                .cornerRadius(8)
                .shadow(radius: 4)

            Button(action: {
                coordinator?.togglePiP()
            }) {
                HStack {
                    Image(systemName: "pip")
                    Text("Start / Stop PiP")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle(video.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Optionally observe scene notifications to auto-start PiP on background
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                coordinator?.tryStartPiPOnBackground()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
}

