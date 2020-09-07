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
    
    struct ImageItem : LoaderItemProtocol {
        let fileName: String
        let request: URLRequest
    }
    
    private var session : URLSession
    private var cache = NSCache<NSString,UIImage>()
    private var requests = Set<URLRequest>()
        
    init(session:URLSession) {
        self.session = session
    }
    
    typealias LoaderResult = (Result<URL,Error>) -> Void
    
}

// MARK: - Implementation

protocol LoaderItemProtocol {
    var fileName: String {get}
    var request: URLRequest {get}
}

extension ImageLoader {
    
    enum Errors : Error {
        case missingStorageURL
        case fileIsNotStored
        case failingRetrieveData
        case isPending
    }
    
    func load(item:LoaderItemProtocol) -> Future<UIImage,Never> {
        
        let futur = Future<UIImage, Never> { (promise) in
            
            if let image = self.cache.object(forKey: NSString(string: item.fileName)) {
                print("[ImageLoader] : Load \(item.fileName) from Cache")
                promise(.success(image))
            }
            
            else if let image = try? self.retrieve(item: item).map({UIImage(contentsOfFile: $0.path)}).get() {
                self.cache.setObject(image, forKey: NSString(string: item.fileName))
                print("[ImageLoader] : Load \(item.fileName) from File")
                promise(.success(image))
            }
            
            else {
                self.download(item: item) { (result) in
                    switch result {
                    case .failure(let err):
                        print("[ImageLoader] : Error Download \(item.fileName) => \(err.localizedDescription)")
                    case .success(let url):
                        if let image = UIImage(data: try! Data(contentsOf: url)) {
                            self.cache.setObject(image, forKey: NSString(string: item.fileName))
                            print("[ImageLoader] : Load \(item.fileName) from Remote")
                            promise(.success(image))
                        } else {
                            print("[ImageLoader] : Cant read \(item.fileName) file format")
                        }
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
                self.cache.setObject(image, forKey: NSString(string: item.fileName))
            }
        default: break
        }
    }
    
    private func couldDownload(request:URLRequest) -> Bool {

        guard self.requests.contains(request) else {
            self.requests.insert(request)
            return true
        }
        
        return false
    }
    
    func download(item:LoaderItemProtocol, Callback:@escaping LoaderResult) {
        
        guard self.couldDownload(request: item.request) else {
            return Callback(.failure(Errors.isPending))
        }
        
        print("Start download")
        self.session.downloadTask(with: item.request) { (tmp, rep, err) in
            if let error = err {
                Callback(.failure(error))
            } else if let local = tmp {
                Callback(self.store(item: item, AtUrl: local))
            }
            self.requests.remove(item.request)
            print("Finish download")
        }.resume()
    }
    
    func retrieve(item:LoaderItemProtocol) -> Result<URL,Error> {
        
        let manager = FileManager.default
        
        let url = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.fileName)
        
        return manager.fileExists(atPath: url.path) ? .success(url) : .failure(Errors.fileIsNotStored)
    }
    
    func delete(item:LoaderItemProtocol) -> Result<URL,Never> {
        
        let manager = FileManager.default
        
        let file = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.fileName)
        
        if manager.fileExists(atPath: file.path) {
            try? manager.removeItem(at: file)
        }
        
        return .success(file)
    }
    
    func remove() {
        
        let manager = FileManager.default
        let dir = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("Loader")
        
        do {
            try manager.removeItem(at: dir)
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func store(item:LoaderItemProtocol, AtUrl:URL) -> Result<URL,Error> {
        
        let manager = FileManager.default
        
        let dir = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0].appendingPathComponent("Loader")
        let file = dir.appendingPathComponent(item.fileName)
        
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
