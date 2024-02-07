//
//  CardView.swift
//  tivy
//
//  Created by Isaac Schiffler on 4/23/23.
//

import SwiftUI

struct CardView: View {
    //let activity: Activity
    let activity: ActivityV3
    var body: some View {
        VStack(alignment: .leading) {
            if activity.mainImage != nil {
                Image(uiImage: activity.mainImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
            }
            Text(activity.title)
                .font(.headline)
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var activity = Activity.sampleData[0]
    static var activity2 = ActivityV3(activityID: "random", title: activity.title, mainImage: UIImage(named: activity.image), description: "", effort: 0.0, time: 0, cost: 0, physical: 0, location: nil, timeOfDay: "Any", moreImages: [], rating: nil, user: nil)
    static var previews: some View {
        CardView(activity: activity2)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
