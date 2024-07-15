//
//  ImagExt.swift
//  Leech
//
//  Created by Samo Vaský on 05/04/2023.
//

import Foundation
import SwiftUI

extension Image {
    func size(width_i: CGFloat, height_i: CGFloat) -> some View{
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width_i,height: height_i)
        
    }
}
