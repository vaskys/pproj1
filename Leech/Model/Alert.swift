//
//  Alert.swift
//  Leech
//
//  Created by Samo Vaský on 12/04/2023.
//

import Foundation


@MainActor
final class Alert : ObservableObject {
    @Published var show_alert: Bool = false
    private var msg_alert: String = ""
   
    func pop_alert(msg: String) {
        show_alert = true
        msg_alert = msg
    }
    
    func get_alert_msg() -> String {
        return msg_alert
    }
    
}
