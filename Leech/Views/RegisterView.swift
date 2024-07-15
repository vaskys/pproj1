//
//  RegisterView.swift
//  Leech
//
//  Created by Samo Vaský on 08/04/2023.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var user:UserAuthVM
    @EnvironmentObject var alerty: Alert
    
    var body: some View {
        VStack {
            AuthInputView(title: "Registracne Udaje", button_label: "Registrovat",type: 1) {
                user.register { (msg: String) in
                    alerty.pop_alert(msg: msg)
                }
            }
        }
        .padding()
        .navigationTitle("Registracia")
       
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(UserAuthVM())
            .environmentObject(Alert())
    }
}
