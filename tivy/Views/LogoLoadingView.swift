//
//  LogoLoadingView.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/7/23.
//

import SwiftUI

struct LogoLoadingView: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: -100)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                .scaleEffect(2.0)
                .padding(20)
                .cornerRadius(10)
                .offset(y: -50)
        }
    }
}

struct LogoLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LogoLoadingView()
    }
}
