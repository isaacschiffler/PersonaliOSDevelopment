//
//  GetActivities.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/1/23.
//

import Foundation
import SwiftUI
import CoreLocation
import Firebase
import FirebaseFirestore

struct ActivityV3: Identifiable, Hashable {
    let id: UUID
    var activityID: String
    var title: String
    var mainImage: UIImage?
    var description: String
    var effort: Double
    var time: Double
    var cost: Double
    var physical: Double
    var location: CLLocationCoordinate2D?
    var timeOfDay: String
    var moreImages: [String]
    var rating: Float?
    var user: String?
    
    init(activityID: String, title: String, mainImage: UIImage?, description: String, effort: Double, time: Double, cost: Double, physical: Double, location: CLLocationCoordinate2D?, timeOfDay: String, moreImages: [String], rating: Float?, user: String?) {
        self.id = UUID()
        self.activityID = activityID
        self.title = title
        self.mainImage = mainImage
        self.description = description
        self.effort = effort
        self.time = time
        self.cost = cost
        self.physical = physical
        self.location = location
        self.timeOfDay = timeOfDay
        self.moreImages = moreImages
        self.rating = rating
        self.user = user
    }
    
    // Implement the Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: ActivityV3, rhs: ActivityV3) -> Bool {
        return lhs.id == rhs.id
    }
}
