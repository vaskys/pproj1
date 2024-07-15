//
//  LibView.swift
//  Leech
//
//  Created by Samo Vaský on 16/04/2023.
//

import SwiftUI

struct LibView: View {
    @EnvironmentObject var lib_vm: LibVM
    @EnvironmentObject var inv_api: IApi
    @EnvironmentObject var alerty: Alert
    
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView(.vertical,showsIndicators: false) {
                    NavigationLink {
                        AutoriView()
                    } label: {
                        HStack {
                            Image(systemName: "person")
                            Text("Autori")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.primary)
                    Divider()
                    NavigationLink {
                        VideaView()
                    } label: {
                        HStack {
                            Image(systemName: "play")
                            Text("Videa")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.primary)
                    Divider()
                    HStack {
                        Text("Naposledy Pridane:")
                            .font(.title.bold())
                        Spacer()
                    }
                    .padding(.top,30)
                    ForEach(lib_vm.get_posledne_videa()) { video in
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
                }.padding(.top)
            }
        }
        .padding()
    }
}

//struct LibView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibView()
//    }
//}
