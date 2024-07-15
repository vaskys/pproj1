//
//  ProfileView.swift
//  Leech
//
//  Created by Samo Vaský on 09/04/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: UserAuthVM
    @EnvironmentObject var alerty: Alert
    @EnvironmentObject var lib_vm: LibVM
    
    var body: some View {
        List {
            Text(auth.get_email())
            Button("Vymazat kniznicu") {
                lib_vm.delete_lib()
                alerty.pop_alert(msg: "Kniznica Vymazana")
            }
            Button() {
                Task {
                    try auth.logout { (msg: String) in
                        alerty.pop_alert(msg: msg)
                    }
                }
            } label: {
                Text("Logout")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserAuthVM())
            .environmentObject(Alert())
    }
}
