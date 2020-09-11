//
//  ImageLoader.swift
//  Pokedex
//
//  Created by owee on 08/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import UIKit
import LCFramework

final class ImageLoader: DataLoader<UIImage> {
    
    static let shared = ImageLoader(Session: URLSession.shared, Convert: {UIImage(data: $0)})
    
}
