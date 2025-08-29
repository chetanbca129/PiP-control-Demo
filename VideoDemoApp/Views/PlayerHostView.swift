//
//  PlayerHostView.swift
//  VideoDemoApp
//
//  Created by 3H5T1N on 28/08/25.
//

import SwiftUI
import AVKit

final class PlayerHostView: UIView {
    let playerLayer: AVPlayerLayer

    init(playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not supported") }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
