//
//  ContentView.swift
//  VideoDemoApp
//
//  Created by 3H5T1N on 28/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = VideoListViewModel()

      var body: some View {
          NavigationView {
              List(vm.videos) { video in
                  NavigationLink(destination: VideoPlayerScreen(video: video)) {
                      Text(video.title)
                  }
              }
              .navigationTitle("Videos")
          }
      }
}


#Preview {
    ContentView()
}
