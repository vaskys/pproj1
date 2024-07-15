//
//  KindFIsherExt.swift
//  Leech
//
//  Created by Samo Vaský on 16/04/2023.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView{
   func loadImage(_ url : URL?) {
       self.kf.indicatorType = .activity
       self.kf.setImage(with: url)
   }

   func loadImage(_ url : String?) {
       guard let urlStr = url else {return}
       self.kf.setImage(with: URL.init(string: urlStr))
   }

}
