//
//  VideoView.swift
//  Leech
//
//  Created by Samo Vaský on 06/04/2023.
//

import SwiftUI
import WebKit

struct EmbedVideoView: UIViewRepresentable {
    let id:String
    
    func makeUIView(context: Context) ->  WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.scrollView.isScrollEnabled = false
           return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let video_url = URL(string: "https://invidious.private.coffee/embed/\(id)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: video_url))
    }
}



struct VideoView: View {
    @EnvironmentObject var inv_api: IApi
    @EnvironmentObject var alerty: Alert
    @EnvironmentObject var lib_vm: LibVM
    
    //lebo sheet publisher
    @State var alert_pop = false
    @State var aler_msg = ""
    
    var body: some View {
        VStack {
            if let video = inv_api.selected_video {
                EmbedVideoView(id: video.videoId)
                    .frame(height: 300)
                Text(video.title)
                    .scaledToFit()
                    .font(.title3)
                
                HStack {
                    Text(video.author)
                    Text(video.viewCount.description)
                    
                    if lib_vm.check_video(video: video) {
                        Image(systemName: "checkmark.diamond.fill").size(width_i: 24, height_i: 24)
                            .onTapGesture {
                                lib_vm.remve_from_lib(video: video)
                                alert_pop.toggle()
                                aler_msg = "Vymazane z kniznice"
                            }
                    }
                    else {
                        Image(systemName: "checkmark.diamond").size(width_i: 24, height_i: 24)
                            .onTapGesture {
                                if lib_vm.add_to_lib(video: video) {
                                    aler_msg = "Pridane do kniznice"
                                }
                                else {
                                    aler_msg = "DB Error"
                                }
                                
                                alert_pop.toggle()
                            }
                    }
                }
                .font(.caption)
                .scaledToFit()
                
                Divider()
                HStack {
                    Text("Odporučane:")
                        .frame(alignment: .bottomTrailing)
                        .font(.title.bold())
                        .padding()
                    Spacer()
                }
                ScrollView(.vertical,showsIndicators: false) {
                    if let recommended = video.recommendedVideos {
                        ForEach(recommended) { recommend in
                            LazyVStack {
                                AImageView(url_string: recommend.get_thumb(), overlay_string: recommend.get_cas(), width: nil, height: 250, max_width: nil, max_height: nil)
                               Text(recommend.title)
                                    .scaledToFit()
                                    .font(.title3)
                                HStack {
                                    Text(recommend.author)
                                    Text(recommend.viewCount.description)
                                }
                                
                            }.onTapGesture {
                                inv_api.get_video(alert: {(msg:String) in alerty.pop_alert(msg: msg)},id: recommend.videoId)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            else {
                ProgressView()
            }
        }
        .alert(aler_msg ,isPresented: $alert_pop) {}
    }

}
