//
//  LogoView.swift
//  Leech
//
//  Created by Samo Vaský on 06/04/2023.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack {
            Image("logo")
                .size(width_i: 250, height_i: 250)
            Text("Youtube Leech")
                .bold()
                .font(.title3)
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
