//
//  ActivityDataManager.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/1/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import MapKit

class ActivityDataManager: ObservableObject {
    @Published var activities: [ActivityV3] = []
    let db = Firestore.firestore()

    init() {
        fetchActivities {
            // The activities array is now sorted based on your preferences
            // Do further processing or update the UI as needed
        }
        
    }

    func fetchActivities(completion: @escaping () -> Void) {
        activities.removeAll()
        var mainImage: UIImage? = nil
        let collection = db.collection("activities")
        collection.getDocuments { [weak self] snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion()
                return
            }

            if let snapshot = snapshot {
                let dispatchGroup = DispatchGroup()

                for document in snapshot.documents {
                    dispatchGroup.enter()

                    let data = document.data()

                    let activityID = document.documentID
                    let title = data["title"] as? String ?? ""
                    let mainImageRef = data["image"] as? String ?? "" //this is the path... need to convert to pull from storage
                    let description = data["description"] as? String ?? ""
                    let effort = data["effort"] as? Double ?? 0.0
                    let time = data["time"] as? Double ?? 0.0
                    let cost = data["cost"] as? Double ?? 0.0
                    let physical = data["physical"] as? Double ?? 0.0
                    let timeofday = data["timeOfDay"] as? String ?? "Any"
                    let geoPoint = data["location"] as? GeoPoint ?? nil
                    let coords: CLLocationCoordinate2D? = (geoPoint != nil) ? CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude) : nil
                    let moreImages = data["moreImages"] as? [String] ?? []
                    let subCol = document.reference.collection("ratings")
                    let rating: Float? = -1.0
                    if let self = self {
                        let rating = self.calcRating(ratingsCol: subCol) //returns -1 if there are no present ratings
                    }
                    let user = data["user"] as? String ?? nil

                    getImageFromPath(imagePath: mainImageRef) { [weak self] image in
                        if let image = image {
                            mainImage = image
                            let activity = ActivityV3(activityID: activityID, title: title, mainImage: mainImage, description: description, effort: effort, time: time, cost: cost, physical: physical, location: coords, timeOfDay: timeofday, moreImages: moreImages, rating: rating, user: user)

                            self?.activities.append(activity)
                        } else {
                            print("Error retrieving activity main image")
                        }

                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    completion() // Call the completion handler when all activities are fetched
                }
            } else {
                completion() // Call the completion handler if there's no snapshot
            }
        }
    }
    

    // Rest of the class code...

    // Sorting method
    /*func sortActivities(with preferences: Preference) async {
        await withTaskGroup(of: Void.self) { group in
            group.async {
                bubbleSort(&self.activities, preference: preferences)
            }
        }
    }*/
    
    func sortActivities(with preferences: Preference) {             //gotta make it so this can be used with await but otherwise works good ish
        bubbleSort(&activities, preference: preferences)
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



func getImageFromPath(imagePath: String, completion: @escaping (UIImage?) -> Void) { //might be very useful...
    if imagePath.isEmpty {
        completion(nil)
        return
    }

    let storageRef = Storage.storage().reference().child(imagePath)
    storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
        if let error = error {
            print("Get image error: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let imageData = data, let image = UIImage(data: imageData) else {
            completion(nil)
            return
        }

        completion(image)
    }
}
