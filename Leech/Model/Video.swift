//
//  Video.swift
//  Leech
//
//  Created by Samo Vaský on 09/05/2023.
//

import Foundation

struct Suggestion: Codable {
    var query: String
    var suggestions: [String]
    
}


struct Thumbnails: Codable {
    var quality: String = ""
    var url: String = ""
    var width: Int32 = 0
    var height: Int32 = 0
    
    enum CodingKeys: String, CodingKey {
        case quality
        case url
        case width
        case height
    }
    
    init() {}
    
}

struct Video : Codable, Identifiable {
    var id = UUID()
    var title: String = ""
    var videoId: String = ""
    
    var lengthSeconds: Int32 = 0
    var viewCount: Int64 = 0
    var author: String = ""
    var authorId: String = ""
    
    var videoThumbnails: [Thumbnails]
    var recommendedVideos: [Video]? = nil
    
    enum CodingKeys: String, CodingKey {
        case title
        case videoId
        case lengthSeconds
        case viewCount
        case author
        case authorId
        case videoThumbnails
        case recommendedVideos
    }
    
    func get_thumb() -> String {
        return videoThumbnails[0].url
    }
    
    func get_cas() -> String {
        let cas = RConfig.secondsToHoursMinutesSeconds(Int(lengthSeconds))
        let do_text: String = "\(cas.0):\(cas.1):\(cas.2)"
        
        return do_text
    }
}
