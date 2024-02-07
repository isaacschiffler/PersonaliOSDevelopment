//
//  CharizardView.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/9/23.
//

import SwiftUI

struct CharizardView: View {
    var body: some View {
        VStack {
            Image("charizard").resizable().aspectRatio(contentMode: .fit)
            Text("CHARIZARD!!!!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.orange)
        }
    }
}

struct CharizardView_Previews: PreviewProvider {
    static var previews: some View {
        CharizardView()
    }
}
