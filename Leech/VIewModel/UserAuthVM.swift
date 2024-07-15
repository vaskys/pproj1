//
//  UserAuthVM.swift
//  Leech
//
//  Created by Samo Vaský on 08/04/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class UserAuthVM: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var password_check: String = ""
   
    @Published private var logged_in: Bool = false
    
   
    func login_google(alert: @escaping (String) -> Void)  {
        Task {
            do {
                guard let top = UIApplication.topViewController() else { return }
                let gid_result = try await GIDSignIn.sharedInstance.signIn(withPresenting: top, hint: "", additionalScopes: ["https://www.googleapis.com/auth/youtube.readonly","https://www.googleapis.com/auth/youtube","https://www.googleapis.com/auth/youtube.force-ssl"])
                guard let id_token: String = gid_result.user.idToken?.tokenString else { return }
                let acces_token: String = gid_result.user.accessToken.tokenString
                let credentials = GoogleAuthProvider.credential(withIDToken: id_token, accessToken: acces_token)
                try await Auth.auth().signIn(with: credentials)
                self.login_current_user()
                
            } catch {
                print(error.localizedDescription)
                alert(error.localizedDescription)
            }
        }
    }
    
    func login(alert: @escaping (String) -> Void) {
        Task {
            do {
                try await Auth.auth().signIn(withEmail: email, password: password)
                self.login_current_user()
            } catch {
                print(error.localizedDescription)
                alert(error.localizedDescription)
            }
        }
    }
    
    func register(alert: @escaping (String) -> Void ) {
        if self.password != self.password_check {
            alert("Passwords dont match")
            self.clear()
            return
        }
        Task {
            do {
                try await Auth.auth().createUser(withEmail: email, password: password)
                self.login() { msg in
                   print(msg)
                }
            } catch {
                print(error.localizedDescription)
                alert(error.localizedDescription)
            }
        }
    }
    
    func login_current_user()  {
        guard let _ = Auth.auth().currentUser else { return }
        
        Task {
            do {
                try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            } catch {
                print(error.localizedDescription)
            }
            logged_in = true
        }
    }
    
    func is_logged_in() -> Bool {
        guard let _ = Auth.auth().currentUser else {
            self.logged_in = false
            return false
        }
        self.logged_in = true
        return true
    }

    func logout(alert: (String) -> Void) throws {
        do {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            logged_in = false
        } catch {
            print(error.localizedDescription)
            alert(error.localizedDescription)
        
        }
    }
    
    func reset_password(alert: @escaping (String) -> Void) {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                alert("Recovery Link na Email")
                
            } catch {
                print(error.localizedDescription)
                alert(error.localizedDescription)
            }
        }
    }
    
    func clear() {
        email = ""
        password = ""
        password_check = ""
    }
    
    
    @ViewBuilder var view_selector: some View {
        if self.logged_in {
           RootView()
        } else {
            LoginView()
        }
    }
    
    func get_email() -> String {
        guard let user = Auth.auth().currentUser else {
            return "no_user"
        }
        return user.email!
    }
    
}
