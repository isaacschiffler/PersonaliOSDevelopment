//
//  UpdateBioField.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/31/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct UpdateBioField: View {
    @Binding var bio: String
    @State private var newBio: String = ""
    @State private var badLength = false
    @State private var success = true
    
    @Environment(\.presentationMode) var presentationMode // Added presentationMode
    
    init(bio: Binding<String>) {
        _bio = bio
        _newBio = State(initialValue: bio.wrappedValue) // Initialize newBio with the initial value of bio
    }
    
    var body: some View {
        ZStack {
            Text("Bio")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .position(x: UIScreen.main.bounds.size.width / 2, y: 68)
                .ignoresSafeArea()
            Text("Bio")
                .position(x: 29, y: 150)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .font(.footnote)
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .overlay(
                    TextView(text: $newBio)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .alignmentGuide(.leading) { _ in 0 }
                        .padding(10)
                        .onChange(of: newBio) { newValue in
                            if newValue.count > 250 {
                                newBio = String(newValue.prefix(250))
                            }
                        }
                    /*.placeholder(when: description.isEmpty, placeholder: {
                     Text("description")
                     .offset(x: 3, y: -72.5)
                     .zIndex(1)
                     .foregroundColor(.gray)
                     .opacity(0.5)
                     })*/ //this makes it so clicking the actual placeholder does nothing
                )
                .frame(width: 350, height: 200)
                .padding(.vertical, 20)
                .position(x: 200, y: 275)

            Button(action: {
                newBio = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .position(x: 350, y: 150)
            
            Button {
                //attempt to submit to firebase and update the bio
                if let uid = Auth.auth().currentUser?.uid {
                    //good
                    let collection = Firestore.firestore().collection("users")
                    let doc = collection.document(uid)
                    
                    doc.updateData(["bio": newBio]) { error in
                        if error == nil {
                            // Error occurred while updating username
                            success = false
                        } else {
                            // Username updated successfully
                            print("success")
                        }
                    }
                    bio = newBio
                    presentationMode.wrappedValue.dismiss() // Dismiss the current view
                } else {
                    print("no id found")
                }

            } label: {
                Text("Submit")
                    .font(.title)
                    .bold()
                    .frame(width: 200, height: 40)
            }
            

            if badLength {
                Text("Improper length: Should be less than 250)")
                    .position(x: UIScreen.main.bounds.size.width / 2, y: 370)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.vertical, 10)
            }
            if !success {
                Text("Error: Failure to update bio")
                    .position(x: UIScreen.main.bounds.size.width / 2, y: 370)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.vertical, 10)
            }
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea()
    }
    
    
    //functions
    
    struct TextView: UIViewRepresentable { //holy fuck this actually wraps the text
        @Binding var text: String
        
        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.delegate = context.coordinator
            return textView
        }
        
        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.text = text
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(text: $text)
        }
        
        class Coordinator: NSObject, UITextViewDelegate {
            @Binding var text: String
            
            init(text: Binding<String>) {
                _text = text
            }
            
            func textViewDidChange(_ textView: UITextView) {
                text = textView.text
            }
        }
    }

}

struct UpdateBioField_Previews: PreviewProvider {
    static var previews: some View {
        UpdateBioField(bio: .constant("this is the bio for now"))
    }
}
