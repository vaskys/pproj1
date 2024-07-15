//
//  AImageView.swift
//  Leech
//
//  Created by Samo Vaský on 14/04/2023.
//
import SwiftUI
import Kingfisher

struct AImageView: View {
    let url_string: String
    let overlay_string: String
    
    let width: CGFloat?
    let height: CGFloat?
    let max_width: CGFloat?
    let max_height: CGFloat?
    
    var body: some View {
        
        KFImage(URL(string: url_string))
            .placeholder {
                ProgressView()
            }
            .resizable()
            .frame(width: width,height: height)
            .frame(maxWidth: max_width, maxHeight: max_height)
            .overlay(alignment: .bottomTrailing) {
                Text(overlay_string)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.5))
                    .padding()
            }
        
//        AsyncImage(url: URL(string: url_string)) { data in
//            if let img = data.image {
//                img
//                .resizable()
//                .frame(width: width, height: height)
//                .frame(maxWidth: max_width,maxHeight: max_height)
//
//                .overlay(alignment: .bottomTrailing) {
//                    Text(overlay_string)
//                        .foregroundColor(.white)
//                        .background(Color.black.opacity(0.5))
//                        .padding()
//                }
//            } else if data.error != nil {
//            Image("logo")
//                .resizable()
//                .frame(height: 250)
//                .frame(maxWidth: .infinity)
//            } else {
//            ProgressView()
//                .padding()
//            }
//        }
    }
}


