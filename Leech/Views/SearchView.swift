//
//  SearchView.swift
//  Leech
//
//  Created by Samo Vaský on 15/04/2023.
//

import SwiftUI

struct SearchView: View {
    @State var search_string: String = ""
    @EnvironmentObject var inv_api: IApi
    @EnvironmentObject var alerty: Alert
    
    var body: some View {
        VStack {
            SearchBar(search_string: $search_string)
            Divider()
            ScrollView(.vertical,showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(zip(inv_api.search_videos.indices, inv_api.search_videos)), id: \.0) { index, video in
                        VStack {
                            AImageView(url_string: video.get_thumb(), overlay_string: video.get_cas(), width: nil, height: 250, max_width: nil, max_height: nil)
                            Text(video.title)
                                .scaledToFit()
                                .font(.title3)
                            HStack {
                                Text(video.author)
                                Text(video.viewCount.description)
                            }
                            .scaledToFit()
                            .font(.caption)
                        }
                        .onTapGesture {
                            inv_api.get_video(alert: {(msg:String) in alerty.pop_alert(msg: msg)},id: video.videoId)
                        }
                        .onAppear() {
                            if index == inv_api.search_videos.count - 1 {
                                inv_api.search(name: inv_api.active_search)
                            }
                        }
                    }
                    if inv_api.loading_data {
                        ProgressView()
                    }
                }
            }
        }
        .padding()
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
