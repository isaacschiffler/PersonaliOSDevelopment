//
//  Login.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/26/23.
//

import SwiftUI
import Firebase

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var userIsLoggedIn: Bool
    @Binding var wantsLogin: Bool

    
    var body: some View {
        VStack(spacing: 20) {
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
                login()
            } label: {
                Text("Login")
                    .font(.title)
                    .bold()
                    .frame(width: 200, height: 40)
            }
            .padding(.top)
            .offset(y: 100)
            
            Button {
                //return to sign up
                wantsLogin = false
            } label: {
                Text("Return to sign up page")
                    .bold()
            }
            .padding(.top, 10)
            .offset(y: 110)

        }
        .frame(width: 350)
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    userIsLoggedIn = isLoggedIn()
                }
            }
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(userIsLoggedIn: .constant(false), wantsLogin: .constant(false))
    }
}
