//
//  SearchView.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/9/23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var activityDataManager: ActivityDataManager
    @State private var searchText = ""

    var filteredActivities: [ActivityV3] {
        if searchText.isEmpty {
            return activityDataManager.activities
        } else {
            return activityDataManager.activities.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                List(filteredActivities, id: \.id) { activity in
                    NavigationLink(destination: DetailView(activity: activity)) {
                        Text(activity.title)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Search")
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(ActivityDataManager())
    }
}
