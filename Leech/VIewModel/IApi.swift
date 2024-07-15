//
//  HomeVM.swift
//  Leech
//
//  Created by Samo Vaský on 09/04/2023.
//

import Foundation
import SwiftUI


@MainActor
final class IApi: ObservableObject {
    @Published var trending_videos: [Video] = []
    @Published var search_videos: [Video] = []
    @Published var search_suggestion: Suggestion? = nil
    
    @Published var present_video = false
    @Published var selected_video: Video? = nil
    @Published var selected_segment = 0
    
    @Published var loading_data:Bool = false
    var page = 1
    var active_search = ""
    
    func reset_search() {
        page = 1
        active_search = ""
    }
    
    func get_search_sugg(text: String) {
        let url_string: String = RConfig.config.get_base_url() + "search/suggestions?q=\(text)"
        let final_string = url_string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: final_string) else {
            return
        }
        
        Task {
            do {
                let (data, response ) = try await URLSession.shared.data(from: url)
                if let status = response as? HTTPURLResponse {
                    if status.statusCode == 200 {
                        let decoded_data = try JSONDecoder().decode(Suggestion.self, from: data)
                        search_suggestion = decoded_data
                    }
                    else {
                        print("ERROR ")
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func search(name: String) {
        active_search = name
        let url_string: String = RConfig.config.get_base_url() + "search?q=\(active_search)&type=video&region=SK&page=\(page)"
        let final_string = url_string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: final_string) else {
            return
        }
        loading_data = true
        Task {
            do {
                let (data, response ) = try await URLSession.shared.data(from: url)
                if let status = response as? HTTPURLResponse {
                    if status.statusCode == 200 {
                        let decoded_data = try JSONDecoder().decode([Video].self, from: data)
                        if page == 1 {
                            search_videos.removeAll()
                            search_videos = decoded_data
                        }
                        else {
                            search_videos += decoded_data
                        }
                        loading_data = false
                        page+=1
                    }
                    else {
                        print(status.statusCode.description)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
   
    
    func get_trending_videos(alert: @escaping (String) -> Void ) {
        var kat = "news"
        switch selected_segment {
        case 0:
            kat = "news"
        case 1:
            kat = "music"
        case 2:
            kat = "movies"
        case 3:
            kat = "gaming"
        default:
            print("MEGALUL")
        }
        
        let url_string: String = RConfig.config.get_base_url() + "trending/?pretty=1&region=SK&type=\(kat)"
        let final_string = url_string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: final_string) else {
            return
        }
        trending_videos.removeAll()
        loading_data = true
        Task {
            do {
                let (data, response ) = try await URLSession.shared.data(from: url)
                if let status = response as? HTTPURLResponse {
                    if status.statusCode == 200 {
                        let decoded_data = try JSONDecoder().decode([Video].self, from: data)
                        trending_videos = decoded_data
                        loading_data = false
                    }
                    else {
                        alert("404")
                    }
                }
            } catch {
                print(error)
                alert(error.localizedDescription)
            }
        }
    }
    
    func get_video(alert: @escaping (String) -> Void,id: String) {
        selected_video = nil
        present_video = true
        
        let url_string: String = RConfig.config.get_base_url() + "videos/\(id)"
        let final_string = url_string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: final_string) else {
            return
        }
        
        loading_data = true
        
        Task {
            do {
                let (data, response ) = try await URLSession.shared.data(from: url)
                if let status = response as? HTTPURLResponse {
                    if status.statusCode == 200 {
                        let decoded_data = try JSONDecoder().decode(Video.self, from: data)
                        selected_video = decoded_data
                        loading_data = false
                    }
                    else {
                        alert("404")
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    

}
