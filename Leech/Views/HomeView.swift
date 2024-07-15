//
//  HomeView.swift
//  Leech
//
//  Created by Samo Vask√Ĺ on 10/04/2023.
//
import SwiftUI
import WebKit

struct HomeView: View {
    @EnvironmentObject var inv_api: IApi
    @EnvironmentObject var auth: UserAuthVM
    @EnvironmentObject var alerty: Alert
    
    
    var body: some View {
        VStack {
            Picker("", selection: $inv_api.selected_segment) {
                Text("Novinky").tag(0)
                Text("Hudba").tag(1)
                Text("Filmy").tag(2)
                Text("Gaming").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: inv_api.selected_segment) { tag in
                inv_api.get_trending_videos { (msg:String) in
                    alerty.pop_alert(msg: msg)
                }
            }
            ScrollView(.vertical,showsIndicators: false) {
                LazyVStack {
                    ForEach(inv_api.trending_videos) { video in
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
                    }
                    if inv_api.loading_data {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if inv_api.trending_videos.isEmpty {
                inv_api.get_trending_videos { (msg:String) in
                    alerty.pop_alert(msg: msg)
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(Alert())
//            .environmentObject(UserAuthVM())
//    }
//}

