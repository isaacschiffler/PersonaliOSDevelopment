//
//  CreateProfileView.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/30/23.
//

import SwiftUI
import Firebase
import Combine
import FirebaseFirestore
import FirebaseAuth

struct CreateProfileView: View {
    @State private var username = ""
    @State private var birth = dob(month: "", year: "", day: "")
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var errs = [0, 0, 0, 0]
    @Binding var userIsLoggedIn: Bool
    @Binding var hasProfile: Bool
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                Text("Profile Setup")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    .offset(y: 20)
                    .padding(.vertical, 20)
                
                VStack() {
                    Text("Title")
                        .fontWeight(.light)
                        .font(.footnote)
                        .padding(.top, 20)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .overlay(
                            TextField("Username", text: $username)
                                .textFieldStyle(.plain)
                                .autocapitalization(.none)
                                .onChange(of: username) { newValue in
                                    if newValue.count > 30 {
                                        username = String(newValue.prefix(30))
                                    }
                                }
                                .offset(x: 10)
                        )
                        .frame(width: 350, height: 40)
                        .padding(.bottom, 20)
                }
                
                VStack() {
                    Text("First Name")
                        .position(x: 30, y: 10)
                        .fontWeight(.light)
                        .font(.footnote)
                        .padding(.top, 10)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .overlay(
                            TextField("First", text: $firstName)
                                .textFieldStyle(.plain)
                                .autocapitalization(.none)
                                .onChange(of: firstName) { newValue in
                                    if newValue.count > 30 {
                                        firstName = String(newValue.prefix(30))
                                    }
                                }
                                .offset(x: 10)

                        )
                        .frame(width: 350, height: 40)
                        .padding(.bottom, 20)
                }
                
                VStack() {
                    Text("Last Name")
                        .position(x: 30, y: 10)
                        .fontWeight(.light)
                        .font(.footnote)
                        .padding(.top, 10)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .overlay(
                            TextField("Last", text: $lastName)
                                .textFieldStyle(.plain)
                                .autocapitalization(.none)
                                .onChange(of: lastName) { newValue in
                                    if newValue.count > 40 {
                                        lastName = String(newValue.prefix(40))
                                    }
                                }
                                .offset(x: 10)
                        )
                        .frame(width: 350, height: 40)
                        .padding(.bottom, 20)
                }
                
                HStack(spacing: 5) {
                    Text("Date of Birth:")
                        .bold()
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .offset(x: 20)
                    Spacer()
                    Spacer()
                    Spacer()
                    NumericInputView(numericInput: $birth.month, title: "Month")
                    Text("-")
                    NumericInputView(numericInput: $birth.day, title: "Day")
                    Text("-")
                    NumericInputView(numericInput: $birth.year, title: "Year")
                    
                }
                //add button to submit and also check to make sure all fields are proper
                //also figure out how to ensure username is unique to the firebase database
                
                Button {
                    //attempt to submit the info
                    errs = checkProfile(username: username.lowercased(), firstName: firstName, lastName: lastName, birth: birth)
                    
                    //if there are any errors
                    if !checkProfileErrors(errs: errs) {
                        //do nothing but update the errors text fields
                    } else {
                        submitProfile()
                    }
                } label: {
                    Text("Create Profile")
                        .font(.title)
                        .bold()
                        .frame(width: 200, height: 40)
                }
                .offset(y: 30)
                
                VStack {
                    if errs[0] == 1 {
                        Text("Username: Already in use or of improper length")
                            .font(.footnote)
                    }
                    if errs[1] == 1 {
                        Text("First Name improper format")
                            .font(.footnote)
                    }
                    if errs[2] == 1 {
                        Text("Last Name improper format")
                            .font(.footnote)
                    }
                    if errs[3] == 1 {
                        Text("Invalid Date of Birth")
                            .font(.footnote)
                    }
                }
                .padding(.top, 15)
            }
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    //functions and stuff
    
    func submitProfile() {
        //submit to firebase
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let collection = db.collection("users")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        var timestamp: Timestamp = Timestamp(seconds: 0, nanoseconds: 0)
        let email = Auth.auth().currentUser?.email
        
        birth.day = addZero(num: birth.day)
        birth.month = addZero(num: birth.month)
        
        // Combine the date components and convert them to a Date object
        if let date = dateFormatter.date(from: "\(birth.month)/\(birth.day)/\(birth.year)") {
            // Convert the Date object to a Timestamp object
            timestamp = Timestamp(date: date)
        } else {
            // Handle invalid date format
            print("Invalid date format")
        }
        
        collection.document(uid!).setData(["username": username.lowercased(),
                                           "first": firstName,
                                           "last": lastName,
                                           "dob": timestamp,
                                           "bio": "",
                                           "email": email!,
                                           "created": FieldValue.serverTimestamp()]) { error in
            if let error = error {
                print("Error setting data: \(error.localizedDescription)")
            } else {
                print("Data set successfully")
                userIsLoggedIn = true
                hasProfile = true
            }
        }
    }
}



struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(userIsLoggedIn: .constant(false), hasProfile: .constant(false))
    }
}



struct dob {
    var month: String
    var day: String
    var year: String
    
    init(month: String, year: String, day: String) {
        self.month = month
        self.year = year
        self.day = day
    }
}

struct NumericInputView: View {
    @Binding var numericInput: String
    let title: String
    
    private var maxLen: Int {
        if title == "Month" || title == "Day" {
            return 2
        } else {
            return 4
        }
    }

    var body: some View {
        TextField("\(title)", text: $numericInput)
            .textFieldStyle(.plain)
            .onChange(of: numericInput) { newValue in
                 if newValue.count > maxLen {
                     numericInput = String(newValue.prefix(maxLen))
                 }
             }
            .keyboardType(.numberPad)
            .onReceive(Just(numericInput)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.numericInput = filtered
                }
            }
            .multilineTextAlignment(.center)
    }
}

func checkProfile(username: String, firstName: String, lastName: String, birth: dob) -> [Int] {
    var numbers = [0, 0, 0, 0]
    
    //check username availibility
    checkUsernameAvailability(username: username) { (isAvailable, error) in
        if let error = error {
            // Handle the error
            print("Error: \(error.localizedDescription)")
        } else {
            if isAvailable {
                // Username is available
                // Move on
            } else {
                // Username already exists
                print("Username already exists")
                numbers[0] = 1 //bad
            }
        }
    }
    //check username is proper length
    if !checkUsernameLength(username: username) {
        numbers[0] = 1 //bad
    }
    
    //check first and last name
    if !checkName(name: firstName) {
        numbers[1] = 1 //bad
    }
    
    if !checkName(name: lastName) {
        numbers[2] = 1 //bad
    }
    
    //check date of birth
    if !checkBirth(birth: birth) {
        numbers[3] = 1 //bad
    }
    
    return numbers
}

func checkUsernameAvailability(username: String, completion: @escaping (Bool, Error?) -> Void) {
    let db = Firestore.firestore()
    let usersCollection = db.collection("users")
    
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
            completion(!usernameExists, nil)
        }
}

func checkUsernameLength(username: String) -> Bool {
    if username.count < 2 || username.count > 31 {
        return false
    }
    return true
}

func checkName(name: String) -> Bool {
    if name.count > 2 && name.count < 31 {
        return true
    }
    else {
        return false
    }
}

func checkBirth(birth: dob) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    var day: String
    var month: String
    
    day = addZero(num: birth.day)
    month = addZero(num: birth.month)
    
    // Combine the date components and convert them to a Date object
    if dateFormatter.date(from: "\(month)/\(day)/\(birth.year)") != nil {
        // good date
        return true
    } else {
        // Handle invalid date format
        print("Invalid date format")
        return false
    }
}

func checkProfileErrors(errs: [Int]) -> Bool {
    for i in 0...3 {
        if errs[i] == 1 {
            return false
        }
    }
    return true
}

func addZero(num: String) -> String {
    var ret = num
    if num.count == 1 {
        ret = "0" + num
    }
    return ret
}
