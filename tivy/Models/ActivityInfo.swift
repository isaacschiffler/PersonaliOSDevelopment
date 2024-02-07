//
//  ActivityInfo.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/10/23.
//

import Foundation
import SwiftUI

class ActivityInfo: ObservedObject<Activity> {
    @Published var activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
    }
}
