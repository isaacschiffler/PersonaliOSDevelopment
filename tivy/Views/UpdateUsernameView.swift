//
//  UpdateUsernameView.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/31/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Combine

struct UpdateUsernameView: View {
    @Binding var username: String
    @State private var newUsername: String
    @State private var inUse = false
    @State private var badLength = false
    
    @Environment(\.presentationMode) var presentationMode // Added presentationMode
    
    init(username: Binding<String>) {
        _username = username
        _newUsername = State(initialValue: username.wrappedValue) // Initialize newBio with the initial value of bio
    }
    
    var body: some View {
        ZStack {
            Text("Username")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .position(x: UIScreen.main.bounds.size.width / 2, y: 68)
                .ignoresSafeArea()
            Text("Username")
                .position(x: 50, y: 150)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .font(.footnote)
            TextField("username", text: $newUsername)
                .position(x: 215, y: 175)
                .textFieldStyle(.plain)
                .autocapitalization(.none)
                .onChange(of: newUsername) { newValue in
                    if newValue.count > 30 {
                        newUsername = String(newValue.prefix(30))
                    }
                }
                .onReceive(Just(newUsername)) { input in
                    let filteredText = input.filter { char in
                        char.isLetter || char.isNumber || char == "_" || char == "."
                    }
                    if filteredText != input {
                        self.newUsername = filteredText
                    }
                }
            Button(action: {
                newUsername = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .position(x: 350, y: 175)
            
            Button {
                //attempt to submit to firebase and update the username
                //verify
                //submit if good
                checkAndUpdateUsername(username: newUsername.lowercased()) { success, error in
                    if let error = error {
                        // Handle the error
                        print("Error: \(error.localizedDescription)")
                    } else if success {
                        // Username updated successfully
                        username = newUsername.lowercased()
                        print("Username updated successfully")
                        presentationMode.wrappedValue.dismiss() // Dismiss the current view
                    } else {
                        // Username already exists or is invalid
                        print("Username already exists or is invalid")
                    }
                }
            } label: {
                Text("Submit")
                    .font(.title)
                    .bold()
                    .frame(width: 200, height: 40)
            }
            .position(x: UIScreen.main.bounds.size.width / 2, y: 300)
            
            if inUse {
                Text("Username already in use")
                    .position(x: UIScreen.main.bounds.size.width / 2, y: 355)
                    .multilineTextAlignment(.center)
            }
            if badLength {
                Text("Improper length: Should be between 2 and 30)")
                    .position(x: UIScreen.main.bounds.size.width / 2, y: 395)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
    }
    
    
    //functions
    
    
    func checkAndUpdateUsername(username: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Check if the username already exists
        usersCollection
            .whereField("username", isEqualTo: username)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    // Error occurred while fetching documents
                    completion(false, error)
                    return
                }
                
                // Check if any documents match the provided username
                let usernameExists = !(querySnapshot?.isEmpty ?? false)
                
                // Validate the username length
                let isUsernameValid = (2...30).contains(username.count)
                
                if usernameExists {
                    // Username already exists
                    inUse = true
                    completion(false, nil)
                } else if !isUsernameValid {
                    // Invalid username length
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid username length. Please provide a username between 2 and 30 characters."])
                    badLength = true
                    completion(false, error)
                } else {
                    inUse = false
                    badLength = false
                    // Update the username field
                    let currentUser = Auth.auth().currentUser
                    
                    guard let uid = currentUser?.uid else {
                        // User is not logged in
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User is not logged in."])
                        completion(false, error)
                        return
                    }
                    
                    let userDocument = usersCollection.document(uid)
                    
                    userDocument.updateData(["username": username]) { error in
                        if let error = error {
                            // Error occurred while updating username
                            userDocument.setData(["username": username])
                            completion(false, error)
                        } else {
                            // Username updated successfully
                            completion(true, nil)
                        }
                    }
                }
            }
    }
}

struct UpdateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUsernameView(username: .constant("isaacSchUsername"))
    }
}

