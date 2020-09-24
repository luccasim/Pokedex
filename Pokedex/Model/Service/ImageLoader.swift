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
import Combine

protocol LoaderProtocol {
    func loadImage(Path:String) -> Future<UIImage, Never>
}

final class ImageLoader: DataLoader<UIImage> {
    
    static let shared = ImageLoader(Session: URLSession.shared,Tracable: true, Convert: {UIImage(data: $0)})
}
