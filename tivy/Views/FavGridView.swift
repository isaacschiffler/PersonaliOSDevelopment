//
//  FavGridView.swift
//  tivy
//
//  Created by Isaac Schiffler on 8/20/23.
//

import SwiftUI

struct FavGridView: View {
    @State var favs: [ActivityV3]
    
    var body: some View {
        NavigationView {
            GridView(favs: $favs)
        }
    }
}

struct FavGridView_Previews: PreviewProvider {
    static var previews: some View {
        FavGridView( favs: [])
    }
}


struct GridView: View {
    @Binding var favs: [ActivityV3]

    let columns: Int = 3 // Number of columns in the grid

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: columns), spacing: 2) {
                ForEach(favs, id: \.self) { activity in
                    NavigationLink(destination: DetailView(activity: activity)) {
                        Image(uiImage: activity.mainImage ?? UIImage(named: "logo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width / CGFloat(columns), height: UIScreen.main.bounds.width / CGFloat(columns)) // Square aspect ratio
                            .clipped() // Ensure that the image stays within the frame
                    }
                }
            }
        }
    }
}
