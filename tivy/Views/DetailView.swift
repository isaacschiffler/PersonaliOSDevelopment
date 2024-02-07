//
//  DetailView.swift
//  tivy
//
//  Created by Isaac Schiffler on 4/23/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import MapKit

struct DetailView: View {
    @State var activity: ActivityV3
    @State var moreImages: [UIImage] = []
    @State private var isLoadingImages = false
    @State var username: String = ""
    @State var isFav = false
    
    
    var body: some View {
        ZStack {
            List {
                Image(uiImage: activity.mainImage!).resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Section(header: Text(activity.title).font(.title)) {
                    Text(activity.description)
                    Text("Ideal time of day for this activity: \(activity.timeOfDay)")
                        .font(.footnote)
                    VStack {
                        Text("Effort:")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ProgressView(value: activity.effort / 5.0)
                        Text("Time:")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ProgressView(value: activity.time / 5.0)
                        Text("Cost:")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ProgressView(value: activity.cost / 5.0)
                        Text("Physical Level:")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ProgressView(value: activity.physical / 5.0)
                    }
                }
                Section(header: Text("Location")) {
                    if activity.location != nil {
                        MapViewRegular(selectedCoordinate: activity.location!)
                            .frame(width: 350, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Text("No location provided...")
                            .font(.footnote)
                    }
                }
                Section(header: Text("Photos")) {
                    VStack {
                        if isLoadingImages {
                            Text("Loading images...")
                                .font(.footnote)
                        } else {
                            if moreImages.isEmpty {
                                Text("No images found...")
                                    .font(.footnote)
                            } else {
                                ForEach(moreImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }
                }
                if (username != "") {
                    Text("Created by: \(username)")
                        .font(.footnote)
                } else {
                    Text("Unknwn creator")
                        .font(.footnote)
                }
            }
            .listStyle(.inset)
            Button(action: { //this works but it doesn't update the list in the profile view.........
                //add to personal fav list...
                if isFav == false {
                    addToFavs(activityID: activity.activityID)
                } else {
                    remFromFavs(activityID: activity.activityID) { error in
                        if let error = error {
                            print("Error removing activity from favorites: \(error.localizedDescription)")
                        } else {
                            print("Activity \(activity.activityID) removed from favorites successfully!")
                        }
                    }
                }
                isFav.toggle()
            }, label: {
                Image(systemName: isFav == true ? "star.fill" : "star")
            })
            .position(x: UIScreen.main.bounds.width - 25, y: 25)
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear {
            isLoadingImages = true
            retrieveMoreImages(from: activity.moreImages) { images in
                DispatchQueue.main.async {
                    self.moreImages = images
                    isLoadingImages = false
                }
            }
            if activity.user != nil {
                getUsernameFromUID(documentID: activity.user!) { username in
                    if username != nil {
                        self.username = username!
                    }
                }
            }
            
            checkFavStatus(activityID: activity.activityID) { isFavorited, error in
                if let error = error {
                    print("Error checking favorite status: \(error.localizedDescription)")
                } else {
                    if isFavorited {
                        print("Activity \(activity.activityID) is favorited by the current user.")
                        isFav = true
                    } else {
                        print("Activity \(activity.activityID) is not favorited by the current user.")
                        isFav = false
                    }
                }
            }
        }
    }
    
    //functions and stuff
    
    func retrieveMoreImages(from imagePaths: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for imagePath in imagePaths {
            dispatchGroup.enter()
            
            // Use the imagePath to retrieve the image from Firebase Storage
            // Example code:
            
            // Assuming you have a function to retrieve the UIImage from a given path
            getImageFromPath(imagePath: imagePath) { image in
                if let image = image {
                    images.append(image)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images) // Return the retrieved images when all asynchronous tasks are completed
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    static var activity = Activity.sampleData[0]
    static var activity2 = ActivityV3(activityID: "random", title: activity.title, mainImage: UIImage(named: activity.image), description: "this is the description", effort: activity.effort, time: activity.time, cost: activity.cost, physical: activity.physical, location: nil, timeOfDay: "Any", moreImages: [], rating: nil, user: nil)
    static var previews: some View {
        DetailView(activity: (activity2))
    }
}


struct MapViewRegular: UIViewRepresentable {
    let selectedCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedCoordinate
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: selectedCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000) //could possibly eventually change so it depends on loc compared to user loc...
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
}


func getUsernameFromUID(documentID: String, completion: @escaping (String?) -> Void) {
    let db = Firestore.firestore()
    let usersCollection = db.collection("users")
    let documentRef = usersCollection.document(documentID)
    
    documentRef.getDocument { document, error in
        if let error = error {
            print("Error retrieving document: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let document = document, document.exists else {
            completion(nil)
            return
        }
        
        if let username = document.data()?["username"] as? String {
            completion(username)
        } else {
            completion(nil)
        }
    }
}

func addToFavs(activityID: String) {
    guard let currentUser = Auth.auth().currentUser else {
        print("User is not logged in.")
        return
    }
    
    let db = Firestore.firestore()
    let uid = currentUser.uid
    
    let userRef = db.collection("users").document(uid)
    
    userRef.getDocument { (document, error) in
        if let document = document, document.exists {
            var favs = document["favs"] as? [String] ?? []
            favs.append(activityID)
            
            userRef.updateData(["favs": favs]) { error in
                if let error = error {
                    print("Error updating favorites: \(error.localizedDescription)")
                } else {
                    print("Activity \(activityID) added to favorites successfully!")
                }
            }
        } else {
            print("User document not found.")
        }
    }
}

func remFromFavs(activityID: String, completion: @escaping (Error?) -> Void) {
    guard let currentUser = Auth.auth().currentUser else {
        let error = NSError(domain: "com.yourapp.remFromFavs", code: -1, userInfo: [NSLocalizedDescriptionKey: "User is not logged in."])
        completion(error)
        return
    }

    let db = Firestore.firestore()
    let uid = currentUser.uid

    // Reference to the user's document in the "users" collection
    let userRef = db.collection("users").document(uid)

    // Get the user's document from Firestore
    userRef.getDocument { (document, error) in
        if let error = error {
            completion(error)
            return
        }

        if let document = document, document.exists {
            // Get the current favorites array from the user's document
            var favs = document["favs"] as? [String] ?? []

            // Find the index of the activity to remove from the array
            if let indexToRemove = favs.firstIndex(of: activityID) {
                favs.remove(at: indexToRemove)

                // Update the favorites array in the user's document
                userRef.updateData(["favs": favs]) { error in
                    completion(error)
                }
            } else {
                // Activity not found in favorites
                let error = NSError(domain: "com.yourapp.remFromFavs", code: -1, userInfo: [NSLocalizedDescriptionKey: "Activity not found in favorites."])
                completion(error)
            }
        } else {
            // User document not found
            let error = NSError(domain: "com.yourapp.remFromFavs", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found."])
            completion(error)
        }
    }
}

func checkFavStatus(activityID: String, completion: @escaping (Bool, Error?) -> Void) {
    guard let currentUser = Auth.auth().currentUser else {
        let error = NSError(domain: "com.yourapp.checkFavStatus", code: -1, userInfo: [NSLocalizedDescriptionKey: "User is not logged in."])
        completion(false, error)
        return
    }

    let db = Firestore.firestore()
    let uid = currentUser.uid

    // Reference to the user's document in the "users" collection
    let userRef = db.collection("users").document(uid)

    // Get the user's document from Firestore
    userRef.getDocument { (document, error) in
        if let error = error {
            completion(false, error)
            return
        }

        if let document = document, document.exists {
            // Get the current favorites array from the user's document
            let favs = document["favs"] as? [String] ?? []

            // Check if the activityID exists in the favorites array
            let isFavorited = favs.contains(activityID)

            completion(isFavorited, nil)
        } else {
            // User document not found
            let error = NSError(domain: "com.yourapp.checkFavStatus", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found."])
            completion(false, error)
        }
    }
}


