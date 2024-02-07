//
//  ActivitySortingAlgo.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/7/23.
//

import Foundation

func bubbleSort(_ array: inout [ActivityV3], preference: Preference?) {
    guard preference != nil else {
        return
    }
    
    guard array.count > 1 else {
        return
    }
    
    let n = array.count
    
    for i in 0..<n {
        var isSwapped = false
        
        for j in 0..<n-i-1 {
            if calcRelevance(preference: preference!, activity: array[j]) > calcRelevance(preference: preference!, activity: array[j+1]) {
                array.swapAt(j, j+1)
                isSwapped = true
            }
        }
        
        // If no swaps were made in the inner loop, the array is already sorted
        if !isSwapped {
            break
        }
    }
}

func calcRelevance(preference: Preference, activity: ActivityV3) -> Double { //still gotta incorporate distance using the activity loc and current user loc
    var relevanceRating: Double = 0
    
    relevanceRating += abs(activity.effort - preference.effort)
    relevanceRating += abs(activity.time - preference.time)
    relevanceRating += abs(activity.cost - preference.cost)
    relevanceRating += abs(activity.physical - preference.physical)
    
    //check for the timeOfDay
    if (preference.timeOfDay == "Any") {
        //do nothing
    }
    else if (preference.timeOfDay == "Daytime") {
        if (activity.timeOfDay == "Late Night") {
            relevanceRating += 2.5
        }
        else if (activity.timeOfDay == "Night") {
            relevanceRating += 1.5
        }
        else if (activity.timeOfDay == "Sunset") {
            relevanceRating += 1.5
        }
        else if (activity.timeOfDay == "Dinner") {
            relevanceRating += 0.5
        }
        else if (activity.timeOfDay == "Sunrise") {
            relevanceRating += 1.5
        }
        else if (activity.timeOfDay == "Breakfast") {
            relevanceRating += 0.5
        }
        else if (activity.timeOfDay == "Morning") {
            relevanceRating += 0.5
        }
        
    }
    else if (preference.timeOfDay == "Sunrise") {
        if (activity.timeOfDay != "Sunrise") {
            relevanceRating += 2.5
        }
        if (activity.timeOfDay == "Morning" || activity.timeOfDay == "Daytime") {
            relevanceRating -= 0.5
        }
    }
    else if (preference.timeOfDay == "Morning") {
        if (activity.timeOfDay != "Morning") {
            relevanceRating += 2.5
        }
        if (activity.timeOfDay == "Sunrise" || activity.timeOfDay == "Daytime") {
            relevanceRating -= 0.5
        }
    }
    else if (preference.timeOfDay == "Breakfast") {
        if activity.timeOfDay != "Breakfast" {
            relevanceRating += 2.5
        }
        if (activity.timeOfDay == "Lunch") {
            relevanceRating -= 0.5
        }
    }
    else if (preference.timeOfDay == "Lunch") {
        if activity.timeOfDay != "Lunch" {
            relevanceRating += 2.5
        }
        if (activity.timeOfDay == "Breakfast") {
            relevanceRating -= 0.5
        }
    }
    else if (preference.timeOfDay == "Afternoon") {
        if activity.timeOfDay != "Afternoon" && activity.timeOfDay != "Daytime"{
            relevanceRating += 2.5
        }
        if activity.timeOfDay == "Lunch"  || activity.timeOfDay == "Dinner"{
            relevanceRating -= 0.5
        }
    }
    else if (preference.timeOfDay == "Dinner") {
        if activity.timeOfDay != "Dinner" {
            relevanceRating -= 2.5
        }
    }
    else if (preference.timeOfDay == "Sunset") {
        if activity.timeOfDay != "Sunset" {
            relevanceRating -= 2.5
        }
    }
    else if (preference.timeOfDay  == "Night") {
        if activity.timeOfDay != "Night" {
            relevanceRating -= 2.5
        }
        if activity.timeOfDay == "Dinner" || activity.timeOfDay == "Late Night" {
            relevanceRating += 1
        }
        
    }
    else if (preference.timeOfDay == "Late Night") {
        if activity.timeOfDay != "Late Night" {
            relevanceRating -= 2.5
        }
        if activity.timeOfDay == "Night" {
            relevanceRating += 1
        }
    }
    
    if activity.timeOfDay == "Any" && preference.timeOfDay != "Any" {
        relevanceRating -= 1
    }

    
    return relevanceRating
}


