//
//  LibVM.swift
//  Leech
//
//  Created by Samo Vaský on 10/05/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore


@MainActor
class LibVM : ObservableObject {
    @Published var lib_vid = [String:Video]()
    @Published var autori = [String:Int]()
    @Published var posledne_videa = [String]()
    
    private var db = Firestore.firestore()
    
    init() {
        get_lib_data()
        get_posledne_data()
    }
    
    
    func delete_lib() {
        lib_vid.values.forEach {
            remove_video_from_db(video: $0)
        }
        remove_posledne_from_db()
        lib_vid.removeAll()
        autori.removeAll()
        posledne_videa.removeAll()
    }
    
    private func get_posledne_data() {
        posledne_videa.removeAll()
        
        let ui = Auth.auth().currentUser!.uid
        let data = db.collection("users").document(ui).collection("posledne").document("last")
        data.getDocument { (document,error) in
            if let error = error {
                print("Error \(error)")
            } else {
                if let document = document, document.exists {
                    let posledne = document.data()
                    if let posledne = posledne {
                        for i in 0..<5 {
                            let key = posledne[String(i)] as! String
                            if key != "" {
                                self.posledne_videa.append(key)
                            }
                        }
                    }
                }
            }
        }
    }
    private func get_lib_data() {
        let ui = Auth.auth().currentUser!.uid
        var _ = db.collection("users").document(ui).collection("lib").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    var thumb = Thumbnails()
                    thumb.url = data["thumbnail"] as! String
                    
                    var video = Video(videoThumbnails: [thumb])
                    video.videoId = data["videoId"] as! String
                    video.title = data["title"] as! String
                    video.lengthSeconds = data["lengthSeconds"] as! Int32
                    video.viewCount = data["viewCount"] as! Int64
                    video.author = data["author"] as! String
                    video.authorId = data["authorId"] as! String
                    
                    self.lib_vid[video.videoId] = video
                }
                self.build_autor()
            }
        }
    }
    
    private func save_posledne_to_db() {
        let ui = Auth.auth().currentUser!.uid
        let data = db.collection("users").document(ui).collection("posledne").document("last")
        var d_data = [String:String]()
        
        for i in 0..<5 {
            if i < posledne_videa.count {
                d_data[String(i)] = posledne_videa[i]
            }
            else {
                d_data[String(i)] = ""
            }
        }
        data.setData(d_data)
    }
    
    private func remove_posledne_from_db() {
        let ui = Auth.auth().currentUser!.uid
        let data = db.collection("users").document(ui).collection("posledne").document("last")
        data.setData([
            "0":"",
            "1":"",
            "2":"",
            "3":"",
            "4":""
        ])
    }
    
    private func save_video_to_db(video: Video) -> Bool {
        let ui = Auth.auth().currentUser!.uid
        let data = db.collection("users").document(ui).collection("lib").document(video.videoId)
        
        data.setData([
            "videoId":video.videoId,
            "title":video.title,
            "lengthSeconds":video.lengthSeconds,
            "viewCount": video.viewCount,
            "author": video.author,
            "authorId": video.authorId,
            "thumbnail": video.videoThumbnails[0].url
        ]) { error in
            if let _ = error {
                print("error")
            } else {
                print("ok")
            }
        }
        return true
    }
    
    private func remove_video_from_db(video: Video) {
        let ui = Auth.auth().currentUser!.uid
        let data = db.collection("users").document(ui).collection("lib").document(video.videoId)
        data.delete()
    }
    
    func remve_from_lib(video: Video) {
        remove_video_from_db(video: video)
        update_autor(key: video.author)
        lib_vid.removeValue(forKey: video.videoId)
        
        posledne_videa.removeAll(where: {
            $0 == video.videoId
        })
    }
    
    
    func add_to_lib(video: Video) -> Bool {
        if save_video_to_db(video: video) {
            lib_vid[video.videoId] = video
            
            posledne_videa.append(video.videoId)
            if posledne_videa.count > 5 {
                posledne_videa.remove(at: 0)
            }
            
            if check_autori(key: video.author) {
                autori[video.author]! += 1
            }
            else {
                autori[video.author] = 1
            }
            save_posledne_to_db()
            return true
        }
        
        return false
    }
    
    func check_video(video: Video) -> Bool {
        guard let _ = lib_vid[video.videoId] else {
            return false
        }
        return true
    }
    
    private func check_autori(key: String) -> Bool {
        guard let _ = autori[key] else {
            return false
        }
        return true
    }
    
    private func update_autor(key: String) {
        if var autor_hodnota = autori[key] {
            autor_hodnota -= 1
            if(autor_hodnota <= 0) {
                autori[key] = nil
            } else {
                autori[key] = autor_hodnota
            }
        }
    }
    
    func get_autor_videa(key: String) -> Array<Video> {
        var videa = [Video]()
        if(check_autori(key: key)) {
            lib_vid.forEach {
                if $0.value.author == key {
                    videa.append($0.value)
                }
            }
        }
        return videa.sorted { $0.title.lowercased() < $1.title.lowercased()}
    }
    
    func get_posledne_videa() -> Array<Video> {
        var arr = [Video]()
        posledne_videa.forEach { id in
            if id != "" {
                arr.append(lib_vid[id]!)
            }
        }
        return arr.reversed()
    }
    
    func get_videa() -> Array<Video> {
        var videa = [Video]()
        videa = Array(lib_vid.values).sorted { $0.title.lowercased() < $1.title.lowercased()}
        return videa
    }
    
    
    private func build_autor() {
        lib_vid.values.forEach { video in
            if check_autori(key: video.author) {
                autori[video.author]! += 1
            }
            else {
                autori[video.author] = 1
            }
        }
    }
}
