//
//  ContentView.swift
//  Leech
//
//  Created by Samo Vaský on 04/04/2023.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @StateObject private var auth = UserAuthVM()
    @StateObject private var alerty =  Alert()
    
    var body: some View {
        VStack {
            auth.view_selector
        }
        .environmentObject(auth)
        .environmentObject(alerty)
        .alert(alerty.get_alert_msg(), isPresented: $alerty.show_alert) {}
        .onAppear {
            RConfig.config.fetch_config()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
