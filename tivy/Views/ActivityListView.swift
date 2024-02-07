//
//  ActivityListView.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/9/23.
//

import SwiftUI

struct ActivityListView: View {
    var activities: [Activity]
    
    var body: some View {
        /*NavigationStack {
         List(activities) { activity in
         NavigationLink(destination: DetailView(activity: activity)) {
         CardView(activity: activity)
         }
         .navigationTitle("Activities")
         }
         .listStyle(.plain)
         }
         .scrollIndicators(.hidden)
         } //old view
         */
        Text("hello world")
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView(activities: (Activity.sampleData))
    }
}
