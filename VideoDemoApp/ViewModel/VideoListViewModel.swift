//
//  VideoListViewModel.swift
//  VideoDemoApp
//
//  Created by 3H5T1N on 28/08/25.
//

import Foundation
import Combine

class VideoListViewModel: ObservableObject {
    @Published var videos: [VideoItem] = [
        VideoItem(title: "Big Buck Bunny", url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!),
        VideoItem(title: "Sintel", url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!),
        VideoItem(title: "Elephant Dream", url: URL(string: "https://test-videos.co.uk/vids/elephantsdream/mp4/h264/720/Elephants_Dream_720_10s_1MB.mp4")!),
        VideoItem(title: "For Bigger Blazes", url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!),
        VideoItem(title: "Tears of Steel", url: URL(string: "https://test-videos.co.uk/vids/tears_of_steel/mp4/h264/720/Tears_of_Steel_720_10s_1MB.mp4")!)
    ]
}
