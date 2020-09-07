//
//  DataLoaderHelper.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol DataLoaderHelperProtocol {
    
    func load(ID:String) -> Data
    
    func download(request:URLRequest)
    
    func store()
    func retrieve()
    func delete()
    
    func clear()
    
}

final class ImageLoader {
    
    private var session : URLSession
    private var cache = NSCache<NSString,UIImage>()
    
    init(session:URLSession) {
        self.session = session
    }
    
    typealias LoaderResult = (Result<URL,Error>) -> Void
    
}

// MARK: - Implementation

protocol LoaderItemProtocol {
    var id: String {get}
    var request: URLRequest {get}
}

extension ImageLoader {
    
    enum Errors : Error {
        case missingStorageURL
        case fileIsNotStored
        case failingRetrieveData
    }
    
    func load(item:LoaderItemProtocol) -> Future<UIImage,Error> {
        
        let futur = Future<UIImage, Error> { (promise) in
            
            if let image = self.cache.object(forKey: NSString(string: item.id)) {
                promise(.success(image))
            }
            
            if let image = try? self.retrieve(item: item).map({UIImage(contentsOfFile: $0.path)}).get() {
                self.cache.setObject(image, forKey: NSString(string: item.id))
                promise(.success(image))
            }
            
            self.download(item: item) { (result) in
                switch result {
                case .failure(let err): promise(.failure(err))
                case .success(let url):
                    if let image = UIImage(contentsOfFile: url.path) {
                        self.cache.setObject(image, forKey: NSString(string: item.id))
                        promise(.success(image))
                    } else {
                        promise(.failure(Errors.failingRetrieveData))
                    }
                }
            }
        }
        
        return futur
    }
    
    func cache(item:LoaderItemProtocol) {
        
        let result = self.retrieve(item: item)
        
        switch result {
        case .success(let url):
            if let image = UIImage(contentsOfFile: url.path) {
                self.cache.setObject(image, forKey: NSString(string: item.id))
            }
        default: break
        }
    }
    
    func download(item:LoaderItemProtocol, Callback:@escaping LoaderResult) {
        
        self.session.downloadTask(with: item.request) { (tmp, rep, err) in
            if let error = err {
                Callback(.failure(error))
            } else if let local = tmp {
                Callback(self.store(item: item, AtUrl: local))
            }
        }.resume()
    }
    
    func retrieve(item:LoaderItemProtocol) -> Result<URL,Error> {
        
        let manager = FileManager.default
        
        let url = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.id)
        
        return manager.fileExists(atPath: url.path) ? .success(url) : .failure(Errors.fileIsNotStored)
    }
    
    func delete(item:LoaderItemProtocol) -> Result<URL,Never> {
        
        let manager = FileManager.default
        
        let file = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.id)
        
        if manager.fileExists(atPath: file.path) {
            try? manager.removeItem(at: file)
        }
        
        return .success(file)
    }
    
    func store(item:LoaderItemProtocol, AtUrl:URL) -> Result<URL,Error> {
        
        let manager = FileManager.default
        
        let dir = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0].appendingPathComponent("Loader")
        let file = dir.appendingPathComponent(item.id)
        
        let dirExist = manager.fileExists(atPath: dir.path)
        
        do {
            
            if !dirExist {
                try manager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
            }
            
            try manager.replaceItem(at: file, withItemAt: AtUrl, backupItemName: nil, options: [], resultingItemURL: nil)

            return .success(file)
            
        } catch let err {
            return .failure(err)
        }
    }
}
