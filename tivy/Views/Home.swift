//
//  Home.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/26/23.
//

import SwiftUI

struct Home: View {
    @State private var selection = 0
    @Binding var isLoggedIn: Bool
    @StateObject var profileDataManager = ProfileDataManager()

    
    var body: some View {
        TabView(selection: $selection) {
            //ActivityListView(activities: Activity.sampleData)
            ActivityListViewV2()
            //CreateActivityView()
                .tabItem {
                    Label("Activities", systemImage: "house")
                }
                .tag(0)

                /*CharizardView()
                .tabItem {
                    TabBarItem(imageName: "charizard 1", label: "Charizard")
                }
                .tag(1)*/
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            ProfileView(isLoggedIn: $isLoggedIn)
                .environmentObject(profileDataManager)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct main_Previews: PreviewProvider {
    static var previews: some View {
        Home(isLoggedIn: .constant(true))
    }
}

struct TabBarItem: View {
    let imageName: String
    let label: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.green)
            
            Text(label)
                .font(.footnote)
        }
    }
}
