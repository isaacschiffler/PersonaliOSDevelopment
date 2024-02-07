//
//  ProfileView.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/9/23.
//

import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestore

struct ProfileView: View { //have to double check on phone but rn the info has like a half second delay until it shows up so possibly initalize the values in the home view and then pass them as bindings to this view so it is instant...
    @EnvironmentObject var profileDataManager: ProfileDataManager
    
    @Binding var isLoggedIn: Bool
    @State var profileImage: UIImage?
    @State var isShowingImagePicker = false
    @State private var name = "Profile Name"
    let favs1 = Activity.sampleData.filter({ $0.isFav })
    @Environment(\.colorScheme) var colorScheme
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var fullName = ""
    @State private var bio = ""
    @State private var favs = [""]
    @State private var favImages: [UIImage] = []
    @State private var favActivities: [ActivityV3] = []
    //get the profile info stuff^^
    
    
    var body: some View {
        NavigationView {
            NavigationStack {
                ZStack {
                    VStack {
                        Button(action: { isShowingImagePicker = true }) {
                            if let image = profileDataManager.Profile.profilePic {
                                //uploadPhoto() if switch to built-in ImagePicker() function on the sheet
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                        }
                        Text(username) //profile name
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        Text(fullName) //full name
                            .font(.headline)
                            .padding(.vertical, 10)
                        Text(bio)
                        Text("Favorited activites:")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                        /*ScrollView {
                         LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                         ForEach(favs) { fav in
                         NavigationLink(destination: DetailView(activity: fav)) {
                         Image(fav.image)
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3, alignment: .center)
                         .clipped()
                         .border(colorScheme == .dark ? Color.black : Color.white, width: 1)
                         }
                         }
                         }
                         }*/
                        /*ScrollView {
                         LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                         ForEach(Array(favs.enumerated()), id: \.element) { index, fav in
                         ImageView(imagePath: "images/activityImages/\(fav)/mainImage.jpg")
                         }
                         }
                         }*/
                        FavGridView(favs: profileDataManager.favs)
                        /*ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                                ForEach(Array(favImages.enumerated()), id: \.element) { index, fav in
                                    Image(uiImage: fav) //still need to make this a navigation link
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3, alignment: .center)
                                        .clipped()
                                        .border(colorScheme == .dark ? Color.black : Color.white, width: 1)
                                }
                            }
                        }*/
                    }
                    HStack {
                        NavigationLink(destination: EditProfileView(username: $username, bio: $bio, profileImage: $profileImage)) { Text("Edit Profile")
                                .font(.footnote)
                        }
                        Spacer()
                        Button {
                            signOut()
                            isLoggedIn = false
                            print("logging out...")
                        } label: {
                            Text("Logout")
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal)
                    .offset(y: -335)
                }
            }
            .onAppear(perform: {
                username = profileDataManager.Profile.username
                fullName = profileDataManager.Profile.fullName
                bio = profileDataManager.Profile.bio
                profileImage = profileDataManager.Profile.profilePic
                favs = profileDataManager.Profile.favActivities
                for i in 0..<favs.count {
                    getImageFromPath(imagePath: "images/activityImages/\(favs[i])/mainImage.jpg") { fetchedImage in
                        DispatchQueue.main.async {
                            if fetchedImage != nil {
                                favImages.append(fetchedImage!)
                            }
                        }
                    }
                }
                /*
                fetchImagesFromPaths(imagePaths: favs) { images in
                    favImages = images.map { ImageWrapper(image: $0) }
                }
                 */
            })
            .refreshable {
                profileDataManager.fetchProfile()
            }
            .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $profileImage, isPresented: $isShowingImagePicker)
                // or could possibly also use ImagePicker(image: $profileImage)
            }
        }
    }
    
    //lowkey might not even need this?
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Binding var isPresented: Bool
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            imagePicker.sourceType = .photoLibrary
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    parent.selectedImage = image
                    uploadPhoto(profileImage: image)
                }
                parent.isPresented = false
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.isPresented = false
            }
        }
    }
}

/*
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
            .environmentObject(MyDataObject())
    }
}
*/

func signOut() {
    do {
        try Auth.auth().signOut()
        // Notify Firebase of the logout (if required)
        // Perform any additional actions after successful logout
    } catch {
        // Handle sign-out error
        print("Error signing out: \(error.localizedDescription)")
    }
}

/*
func fetchProfileInfo() -> [String] {
    let docId = Auth.auth().currentUser!.uid
    let collectionRef = Firestore.firestore().collection("users")
    var info: [String] = ["", "", "", ""]

    collectionRef.document(docId).getDocument { (document, error) in
        if let document = document, document.exists {
            // Document data is available in 'document'
            let documentData = document.data()
            // Process the document data as needed
            print(documentData as Any)
            //get username
            let username = documentData?["username"] as? String ?? ""
            let firstName = documentData?["first"] as? String ?? ""
            let lastName = documentData?["last"] as? String ?? ""
            let bio = documentData?["bio"] as? String ?? ""
            info[0] = username
            info[1] = firstName
            info[2] = lastName
            info[3] = bio
            
            
        } else {
            // Document does not exist or there was an error
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                print("Document does not exist")
            }
        }
    }
    return info
}
 */

func retrieveProfileData(documentID: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
    let db = Firestore.firestore()
    let collectionRef = db.collection("users")
    let documentRef = collectionRef.document(documentID)
    
    documentRef.getDocument { (document, error) in
        if let error = error {
            // Error occurred while fetching the document
            completion(nil, error)
        } else if let document = document, document.exists {
            // Document exists, retrieve the data
            completion(document, nil)
        } else {
            // Document does not exist
            completion(nil, nil)
        }
    }
}

func uploadPhoto(profileImage: UIImage?) {
    
    //make sure image isn't nil
    guard profileImage != nil else {
        return
    }
    
    // create storage reference
    let storageRef = Storage.storage().reference()
    
    //turn image into data
    let imageData = profileImage!.jpegData(compressionQuality: 0.8)
    
    guard imageData != nil else {
        return
    }
    
    //specify the filepath and name
    let userID = Auth.auth().currentUser?.uid
    guard userID != nil else {
        return
    }
    
    let path = "images/profile/\(userID!).jpg"
    let fileRef = storageRef.child(path)
    
    //upload the data
    let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
        if error == nil && metadata != nil {
            //save reference to the file in firestore DB
            //can wait to do this later once a database is created to store the image ref
            let db = Firestore.firestore()
            let collection = db.collection("users")
            let document = collection.document(userID!)
            document.updateData(["profilePic": path]) { error in
                if let error = error {
                    document.setData(["profilePic": path]) { error in
                        if let error = error {
                            print("Error creating data set for uid \(error.localizedDescription)")
                        } else {
                            print("created new document and added photo for uid")
                        }
                    }
                    print("Error updating document: \(error.localizedDescription)")
                }
                else {
                    print("Document uploaded successfully")
                }
            }
        }
    }
}

struct ImageView: View {
    @State private var image: UIImage?
    let imagePath: String

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onAppear {
                    loadImageFromPath()
                }
        } else {
            // Show a placeholder or loading view while the image is being fetched
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    loadImageFromPath()
                }
        }
    }

    private func loadImageFromPath() {
        getImageFromPath(imagePath: imagePath) { fetchedImage in
            DispatchQueue.main.async {
                self.image = fetchedImage
            }
        }
    }
}

struct ImageWrapper: Identifiable {
    let id: UUID = UUID()
    let image: UIImage
}

func fetchImagesFromPaths(imagePaths: [String], completion: @escaping ([UIImage]) -> Void) {
    DispatchQueue.global().async {
        let group = DispatchGroup()
        var images: [UIImage] = []

        for imagePath in imagePaths {
            group.enter()
            getImageFromPath(imagePath: "images/activityImages/\(imagePath)/mainImage.jpg") { fetchedImage in
                if let image = fetchedImage {
                    images.append(image)
                }
                group.leave()
            }
        }

        group.wait()

        DispatchQueue.main.async {
            completion(images)
        }
    }
}

//write a function to retrieve the favorite activity array and then convert into an array of images
func retrieveFavs(completion: @escaping ([String]?, Error?) -> Void) {
    guard let currentUser = Auth.auth().currentUser else {
        let error = NSError(domain: "com.yourapp.retrieveFavs", code: -1, userInfo: [NSLocalizedDescriptionKey: "User is not logged in."])
        completion(nil, error)
        return
    }

    let db = Firestore.firestore()
    let uid = currentUser.uid

    // Reference to the user's document in the "users" collection
    let userRef = db.collection("users").document(uid)

    // Get the user's document from Firestore
    userRef.getDocument { (document, error) in
        if let error = error {
            completion(nil, error)
            return
        }

        if let document = document, document.exists {
            // Get the current favorites array from the user's document
            let favs = document["favs"] as? [String] ?? []

            completion(favs, nil)
        } else {
            // User document not found
            let error = NSError(domain: "com.yourapp.retrieveFavs", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found."])
            completion(nil, error)
        }
    }
}

func retrieveFavs2() -> [String]? {
    var fetchedFavs: [String]? = nil
    
    guard let currentUser = Auth.auth().currentUser else {
        let error = NSError(domain: "com.yourapp.retrieveFavs", code: -1, userInfo: [NSLocalizedDescriptionKey: "User is not logged in."])
        // Signal the semaphore to release it
        return nil
    }

    let db = Firestore.firestore()
    let uid = currentUser.uid

    // Reference to the user's document in the "users" collection
    let userRef = db.collection("users").document(uid)

    // Get the user's document from Firestore
    userRef.getDocument { (document, error) in
        if let error = error {
            // Handle the error and signal the semaphore
            fetchedFavs = nil
            return
        }

        if let document = document, document.exists {
            // Get the current favorites array from the user's document
            let favs = document["favs"] as? [String] ?? []
            fetchedFavs = favs
        } else {
            // User document not found
            let error = NSError(domain: "com.yourapp.retrieveFavs", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found."])
            fetchedFavs = nil
        }
    }
    
    
    return fetchedFavs
}

//get image paths
func getFavImagePaths(activityIDs: [String], completion: @escaping ([String], Error?) -> Void) {
    let db = Firestore.firestore()
    let collection = db.collection("activities")
    
    var imagePaths: [String] = []

    let dispatchGroup = DispatchGroup()

    for activityID in activityIDs {
        dispatchGroup.enter()

        let documentRef = collection.document(activityID)

        documentRef.getDocument { (document, error) in
            if let error = error {
                dispatchGroup.leave()
                completion([], error)
                return
            }

            if let document = document, document.exists {
                if let imagePath = document["image"] as? String {
                    imagePaths.append(imagePath)
                }
            }

            dispatchGroup.leave()
        }
    }

    dispatchGroup.notify(queue: .main) {
        completion(imagePaths, nil)
    }
}

//image paths to image array
func pathArrayToImages(imagePaths: [String], completion: @escaping ([UIImage], Error?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()

    var images: [UIImage] = []
    let dispatchGroup = DispatchGroup()

    for imagePath in imagePaths {
        dispatchGroup.enter()

        // Reference to the image in Firebase Storage
        let imageRef = storageRef.child(imagePath)
        
        // Fetch image data from Storage
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                dispatchGroup.leave()
                completion([], error)
                return
            }

            if let data = data, let image = UIImage(data: data) {
                images.append(image)
            }

            dispatchGroup.leave()
        }
    }

    // Notify completion when all requests are done
    dispatchGroup.notify(queue: .main) {
        completion(images, nil)
    }
}
