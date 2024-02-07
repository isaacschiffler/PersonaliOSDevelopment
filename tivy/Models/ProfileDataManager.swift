//
//  ProfileDataManager.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/30/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import MapKit

class ProfileDataManager: ObservableObject {
    @Published var Profile: profile = profile(username: "def", profilePic: nil, firebaseUID: "def", email: "def", fullName: "def", profileName: "def", bio: "def", favActivities: [], completeActivities: [], createdActivities: [], friends: [], pendFriends: [])
    @Published var favs: [ActivityV3] = []
    var favIDs: [String] = []

    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    init() {
        fetchProfile()
    }
    
    func fetchProfile() {
        let collection = db.collection("users")
        let document = collection.document(uid)
        var profilePic: UIImage? = nil
        
        
        document.getDocument { snapshot, error in

            if let error = error {
                print("Error retrieving document: \(error)")
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("Document does not exist")
                return
            }
            
            if let data = snapshot.data() {
                // Process the data retrieved from the document
                // You can access individual fields using the keys
                let username = data["username"] as? String ?? ""
                let profilePicPath = data["profilePic"] as? String ?? ""
                let firebaseUID = data["firebaseUID"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let firstName = data["firstName"] as? String ?? ""
                let lastName = data["lastName"] as? String ?? ""
                let profileName = data["profileName"] as? String ?? ""
                let bio = data["bio"] as? String ?? ""
                let favActivities = data["favs"] as? [String] ?? []
                let completedActivities = data["completedActivities"] as? [String] ?? []
                let createdActivities = data["createdActivities"] as? [String] ?? []
                let friends = data["friends"] as? [String] ?? []
                let pendFriends = data["pendFriends"] as? [String] ?? []
                
                
                getImageFromPath(imagePath: profilePicPath) { image in
                    if let image = image {
                        profilePic = image
                        //put it all together
                        // Create a Profile instance using the retrieved data
                        self.Profile = profile(username: username, profilePic: profilePic, firebaseUID: firebaseUID, email: email, fullName: firstName + " " + lastName, profileName: profileName, bio: bio, favActivities: favActivities, completeActivities: completedActivities, createdActivities: createdActivities, friends: friends, pendFriends: pendFriends)
                        
                    } else {
                        // Handle error or use a default image
                        self.Profile = profile(username: username, profilePic: nil, firebaseUID: firebaseUID, email: email, fullName: firstName + " " + lastName, profileName: profileName, bio: bio, favActivities: favActivities, completeActivities: completedActivities, createdActivities: createdActivities, friends: friends, pendFriends: pendFriends)
                        
                        print("error retreiving profile main image")
                    }
                    
                    
                    // Use the profile object as needed
                    print("Retrieved profile: \(self.Profile.username)")
                }
                
                self.fetchGivenActivities(favIDs: favActivities) {
                    // This completion handler will be called when fetching is complete
                    // You can update your UI or perform other tasks here
                    print("Fetching fav activities complete: \(favActivities)")
                }
            }
        }
    }
    
    func fetchGivenActivities(favIDs: [String],completion: @escaping () -> Void) {
        favs.removeAll()
        let collection = db.collection("activities")
        
        let dispatchGroup = DispatchGroup() // Create a dispatch group

        for activity in favIDs {
            let document = collection.document(activity)
            dispatchGroup.enter() // Enter the dispatch group
            
            document.getDocument { [weak self] snapshot, error in
                if let error = error {
                    print("Error retrieving document: \(error)")
                    dispatchGroup.leave() // Leave the dispatch group on error
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else {
                    print("Document does not exist")
                    dispatchGroup.leave() // Leave the dispatch group if document does not exist
                    return
                }
                
                if let data = snapshot.data() {
                    let activityID = document.documentID
                    let title = data["title"] as? String ?? ""
                    let mainImageRef = data["image"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let effort = data["effort"] as? Double ?? 0.0
                    let time = data["time"] as? Double ?? 0.0
                    let cost = data["cost"] as? Double ?? 0.0
                    let physical = data["physical"] as? Double ?? 0.0
                    let timeofday = data["timeOfDay"] as? String ?? "Any"
                    let geoPoint = data["location"] as? GeoPoint ?? nil
                    let coords: CLLocationCoordinate2D? = (geoPoint != nil) ? CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude) : nil
                    let moreImages = data["moreImages"] as? [String] ?? []
                    let subCol = document.collection("ratings")
                    var rating: Float? = -1.0 // Set your default value here
                    if let self = self {
                        rating = self.calcRating(ratingsCol: subCol) // Calculate rating if self is available
                    }
                    let user = data["user"] as? String ?? nil

                    getImageFromPath(imagePath: mainImageRef) { [weak self] image in
                        if let image = image {
                            let activity = ActivityV3(activityID: activityID, title: title, mainImage: image, description: description, effort: effort, time: time, cost: cost, physical: physical, location: coords, timeOfDay: timeofday, moreImages: moreImages, rating: rating, user: user)
                            self?.favs.append(activity)
                        } else {
                            print("Error retrieving activity main image")
                        }
                        
                        dispatchGroup.leave() // Leave the dispatch group after image retrieval
                    }
                }
            }
        }
        
        // Notify when all tasks in the dispatch group are completed
        dispatchGroup.notify(queue: .main) {
            completion() // Call the completion handler when all activities are fetched
        }
    }
    
    
    func calcRating(ratingsCol: CollectionReference) -> Float {
        var totalRating: Float = 0
        var count: Float = 0
        
        //add up all ratings and divide by total count
        ratingsCol.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    totalRating += data["rate"] as? Float ?? 0
                    count += 1
                }
            }
        }
        if count != 0 {
            return totalRating / count
        }
        else {
            return -1.0
        }
    }
}
