//
//  ContentView.swift
//  tivy
//
//  Created by Isaac Schiffler on 4/16/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View { //gotta fix it so they're forced to create a profile..........
    @State private var userIsLoggedIn = isLoggedIn()
    @State private var wantsLogin = false
    @State private var hasProfile = false
    @StateObject var activityDataManager = ActivityDataManager()
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    

    var body: some View {
        if userIsLoggedIn {
            Home(isLoggedIn: $userIsLoggedIn)
                .environmentObject(activityDataManager)
        } else if wantsLogin {
            Login(userIsLoggedIn: $userIsLoggedIn, wantsLogin: $wantsLogin)
        } else {
            SignUp(userIsLoggedIn: $userIsLoggedIn, wantsLogin: $wantsLogin, hasProfile: $hasProfile)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func isLoggedIn() -> Bool {
    if Auth.auth().currentUser != nil {
        // User is logged in
        print("User is logged in")
        print(Auth.auth().currentUser?.email as Any)
        return true
    } else {
        // User is not logged in
        print("User is not logged in")
        return false
    }
}

func checkProfile() -> Bool { //this funciton doesn't fucking work
    var exists = false
    
    guard let currentUserID = Auth.auth().currentUser?.uid else {
        print("User not authenticated")
        return false
    }
    
    let docRef = Firestore.firestore().collection("users").document(currentUserID)
    
    docRef.getDocument { (document, error) in
        if let error = error {
            print("Error retrieving document: \(error.localizedDescription)")
            return
        }
        
        if let document = document, document.exists {
            // Document exists for the current user
            exists = true
        } else {
            // Document does not exist for the current user
            print("couldn't find the document to match...")
            print("uid: \(currentUserID)")
        }
    }
    return exists
}

