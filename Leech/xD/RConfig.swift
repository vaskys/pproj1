//
//  RConfig.swift
//  Leech
//
//  Created by Samo Vaský on 13/04/2023.
//

import Foundation
import Firebase
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

class RConfig {
    private var api_key: String;
    private var base_url: String
    
    public static let config = RConfig();
    
    static func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    init() {
        self.api_key = "nic";
//        self.base_url = "https://invidious.snopyta.org/api/v1/"
        self.base_url = "https://invidious.private.coffee/api/v1/"
    }
    
    func fetch_config() {
        Task {
            do{
                let remote_config = RemoteConfig.remoteConfig()
                let settings = RemoteConfigSettings()
                settings.minimumFetchInterval = 0
                remote_config.configSettings = settings
                
                let config = try await remote_config.fetchAndActivate()
                switch config {
                case .successFetchedFromRemote :
                    self.api_key = remote_config.configValue(forKey: "api_key").stringValue ?? self.api_key
                    self.base_url = remote_config.configValue(forKey: "url").stringValue ?? self.base_url
                    
                case .successUsingPreFetchedData:
                    self.api_key = remote_config.configValue(forKey: "api_key").stringValue ?? self.api_key
                    self.base_url = remote_config.configValue(forKey: "url").stringValue ?? self.base_url
                default:
                    print("error")
                }
                print("Toto je api key \(self.api_key) \n")
                print("Toto je URL \(self.base_url)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func get_api_key() -> String {
        return self.api_key;
    }
    
    func get_base_url() -> String {
        return self.base_url
    }
    
   
}

