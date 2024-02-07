//
//  LogoView.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/7/23.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
