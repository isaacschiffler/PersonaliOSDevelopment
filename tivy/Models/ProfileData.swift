//
//  ProfileData.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/5/23.
//

import Foundation
import SwiftUI
import CoreLocation
import Firebase

struct profile: Identifiable {
    let id = UUID() // Unique identifier for the profile
    
    let username: String
    let profilePic: UIImage?
    let firebaseUID: String
    let email: String
    let fullName: String
    let profileName: String
    let bio: String
    let favActivities: [String] // Array to store favorite activity IDs
    let completeActivities: [String] // Array to store completed activity IDs
    let createdActivities: [String] // Array to store created activity IDs
    let friends: [String] //Array to store friends user IDs
    let pendFriends: [String] //Array to store pending friend requests by user IDs

    init(username: String, profilePic: UIImage?, firebaseUID: String, email: String, fullName: String, profileName: String, bio: String, favActivities: [String], completeActivities: [String], createdActivities: [String], friends: [String], pendFriends: [String]) {
        self.username = username
        self.profilePic = profilePic
        self.firebaseUID = firebaseUID
        self.email = email
        self.fullName = fullName
        self.profileName = profileName
        self.bio = bio
        self.favActivities = favActivities
        self.completeActivities = completeActivities
        self.createdActivities = createdActivities
        self.friends = friends
        self.pendFriends = pendFriends
    }
}
