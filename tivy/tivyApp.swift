//
//  tivyApp.swift
//  tivy
//
//  Created by Isaac Schiffler on 4/16/23.
//

import SwiftUI
import Firebase

@main
struct tivyApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
