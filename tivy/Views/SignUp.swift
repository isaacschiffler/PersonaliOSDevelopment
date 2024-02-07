//
//  SignUp.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/26/23.
//

import SwiftUI
import Firebase

struct SignUp: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var userIsLoggedIn: Bool
    @Binding var wantsLogin: Bool
    @Binding var hasProfile: Bool
    @State private var profileTime = false
    
    var body: some View {
        if profileTime == false && Auth.auth().currentUser == nil {
            content
        }
        else {
            CreateProfileView(userIsLoggedIn: $userIsLoggedIn, hasProfile: $hasProfile)
        }
    }
    
    var content: some View {
        VStack(spacing: 10) {
            Text("Welcome")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                .offset(y: -100)
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .overlay(
                    TextField("", text: $email)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                        }
                        .offset(x: 10)
                        .autocapitalization(.none)
                )
                .frame(width: 350, height: 40)
                .padding(.vertical, 20)
                        
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .overlay(
                    SecureField("", text: $password)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                        }
                        .offset(x: 10)
                )
                .frame(width: 350, height: 40)
                .padding(.vertical, 20)
            
            Button {
                register()
            } label: {
                Text("Sign up")
                    .font(.title)
                    .bold()
                    .frame(width: 200, height: 40)
            }
            .padding(.top)
            .offset(y: 100)
            
            Button {
                wantsLogin = true
            } label: {
                Text("Already have an account? Login")
                    .bold()
            }
            .padding(.top)
            .offset(y: 110)
        }
        .frame(width: 350)
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    userIsLoggedIn = false
                    profileTime = true
                }
            }
        }
        .ignoresSafeArea()
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("createUser success")
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(userIsLoggedIn: .constant(false), wantsLogin: .constant(false), hasProfile: .constant(false))
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
        ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
        }
    }
}
