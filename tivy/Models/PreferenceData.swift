//
//  PreferenceData.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/7/23.
//

import Foundation

struct Preference: Identifiable {
    let id = UUID()
    
    var effort: Double
    var time: Double
    var cost: Double
    var distance: Double
    var physical: Double
    var timeOfDay: String
    
    init(effort: Double, time: Double, cost: Double, distance: Double, physical: Double, timeOfDay: String) {
        self.effort = effort
        self.time = time
        self.cost = cost
        self.distance = distance
        self.physical = physical
        self.timeOfDay = timeOfDay
    }
}
