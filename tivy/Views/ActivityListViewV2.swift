//
//  ActivityListViewV2.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/1/23.
//

import SwiftUI

struct ActivityListViewV2: View {
    @EnvironmentObject var activityDataManager: ActivityDataManager
    @State private var showCreateActivityView = false
    @State private var pref: Preference? = nil
    @State private var hasPref = false
    @State private var isLoading = true
    
    var body: some View {
        if hasPref {
            mainListView
        } else {
            PreferenceView(hasPref: $hasPref, pref: $pref)
        }
    }
    
    var mainListView: some View {
        NavigationView {
            if isLoading {
                List {                  //double check this looks how i want
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(2.0)
                        .padding(20)
                }
                .navigationBarTitle("Activities")
                .listStyle(.inset)
            } else {
                List(activityDataManager.activities, id: \.id) { activity in
                    NavigationLink(destination: DetailView(activity: activity)) {
                        CardView(activity: activity)
                    }
                }
                .listStyle(.plain)
                .navigationBarTitle("Activities")
                .navigationBarItems(trailing:
                                        Button(action: {
                    showCreateActivityView.toggle()
                }) {
                    Image(systemName: "plus")
                }
                )
            }
        }
        .onAppear {
            Task {
                await loadData()
            }
        }
        .sheet(isPresented: $showCreateActivityView) {
            CreateActivityView(showCreateActivityView: $showCreateActivityView)
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
        .refreshable {
            isLoading = true
            await loadData()
        }
    }
    
    //functions and stuff
    
    
    func loadData() async { //this basically works so i think it should be good as is??
        // Perform the data loading from Firebase here
        // For example, fetch activities from Firebase and update the activityDataManager
        activityDataManager.fetchActivities {
            if pref != nil {
                activityDataManager.sortActivities(with: pref!) //gotta make this await i think, then can maybe get rid of loading screen...
            }
            isLoading = false
        }
    }
}

struct ActivityListViewV2_Previews: PreviewProvider {

    static var previews: some View {
        ActivityListViewV2()
            .environmentObject(ActivityDataManager())
    }
}
