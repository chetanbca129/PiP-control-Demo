//
//  VideoItem.swift
//  VideoDemoApp
//
//  Created by 3H5T1N on 28/08/25.
//

import Foundation

struct VideoItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let url: URL
}
