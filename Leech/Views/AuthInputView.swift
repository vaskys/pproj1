//
//  AuthInputView.swift
//  Leech
//
//  Created by Samo Vaský on 08/04/2023.
//

import SwiftUI


struct AuthInputView: View {
    @EnvironmentObject var user:UserAuthVM
    
    let title: String
    let button_label: String
    let type: Int
    
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity,alignment: .leading)
            switch type {
            case 0 :
                TextField("Email", text: $user.email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Heslo", text: $user.password)
                    .textFieldStyle(.roundedBorder)
            case 1:
                TextField("Email", text: $user.email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Heslo", text: $user.password)
                    .textFieldStyle(.roundedBorder)
                SecureField("Heslo", text: $user.password_check)
                    .textFieldStyle(.roundedBorder)
            default:
                TextField("Email", text: $user.email)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button  {
                guard let a = action else { return }
                a()
               
            } label: {
               Text(button_label)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.red)
            .clipShape(Capsule())
        }
    }
}

struct AuthInputView_Previews: PreviewProvider {
    static var previews: some View {
        AuthInputView(title: "title test", button_label: "button label",type: 0)
            .environmentObject(UserAuthVM())
    }
}
