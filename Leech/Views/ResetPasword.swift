//
//  ResetPasword.swift
//  Leech
//
//  Created by Samo Vaský on 09/04/2023.
//

import SwiftUI

struct ResetPasword: View {
    @EnvironmentObject var user:UserAuthVM
    @EnvironmentObject var alerty: Alert
    
    var body: some View {
        VStack {
            AuthInputView(title: "Email", button_label: "Reset",type: -1) {
                user.reset_password { (msg: String) in
                    alerty.pop_alert(msg: msg)
                }
            }
        }
        .padding()
        .navigationTitle("Obnova Hesla")
    }
}

struct ResetPasword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasword()
            .environmentObject(UserAuthVM())
            .environmentObject(Alert())
    }
}
