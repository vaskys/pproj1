//
//  VideaView.swift
//  Leech
//
//  Created by Samo Vaský on 10/05/2023.
//

import SwiftUI

struct VideaView: View {
    @EnvironmentObject var lib_vm: LibVM
    @EnvironmentObject var inv_api: IApi
    @EnvironmentObject var alerty: Alert
    
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: true) {
            ForEach(lib_vm.get_videa()) { video in
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
        }
        .navigationTitle("Videa")
    }
}

//struct VideaView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideaView()
//    }
//}
