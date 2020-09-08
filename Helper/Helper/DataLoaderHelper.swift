//
//  DataLoaderHelper.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine

/// Help to Manage Download Data with Cache and
/// persistence store.
///
/// Load a local ressource and cache it.
/// If it does not exist, download it.
///
/// Allows operation for clean the cache,
/// and remove the local data.
protocol DataLoaderHelperProtocol {
    
    associatedtype DataMapped
    
    func load(Url:URL, Callback:@escaping((DataMapped) -> Void))
    func load(Item:LoaderItemProtocol, Callback:@escaping((DataMapped) -> Void))
    
    func load(Url:URL) -> Future<DataMapped,Never>
    func load(Item:LoaderItemProtocol) -> Future<DataMapped,Never>
    
    func cleanCache()
    func removeAllStorage()
}

/// If your source need credential to access,
/// you should use this protocol for retrieve your data
protocol LoaderItemProtocol {
    var fileName: String {get}
    var request: URLRequest {get}
}

/// Standart struct for send a specifique request.
/// You could set the file name to save.
struct LoaderItem : LoaderItemProtocol {
    let fileName: String
    let request: URLRequest
}

/// This generic implement the DataLoaderHelperProtocol.
/// For use we recommand to inherit with the appropiate Data.
/// This class use NSCache and FileManager for manage the data.
class DataLoader<T:AnyObject> : DataLoaderHelperProtocol {
    
    private var session : URLSession
    private var cache = NSCache<NSString,T>()
    private var requests = Set<URLRequest>()
    private var cancellable = Set<AnyCancellable>()
    
    var convertData : ((Data) -> T?)
        
    init(Session:URLSession, Convert: @escaping((Data)->T?)) {
        self.session = Session
        self.convertData = Convert
    }
}

// MARK: - Implementation

extension DataLoader {
    
    func load(Url:URL, Callback:@escaping((T) -> Void)) {
        let futur = self.load(Url: Url)
            .sink {Callback($0)}
        self.cancellable.insert(futur)
    }
    
    func load(Item:LoaderItemProtocol, Callback:@escaping((T) -> Void)) {
        let futur = self.load(Item: Item)
            .sink {Callback($0)}
        self.cancellable.insert(futur)
    }
    
    func load(Url:URL) -> Future<T,Never> {
        let item = LoaderItem(fileName: Url.lastPathComponent, request: URLRequest(url: Url))
        return load(Item: item)
    }
        
    func load(Item:LoaderItemProtocol) -> Future<T,Never> {
        
        let futur = Future<T, Never> { (promise) in
            
            if let obj = self.cache.object(forKey: NSString(string: Item.fileName)) {
                print("[ImageLoader] : Load \(Item.fileName) from Cache")
                promise(.success(obj))
            }
            
            else if let obj = self.retrieve(item: Item) {
                self.cache.setObject(obj, forKey: NSString(string: Item.fileName))
                print("[ImageLoader] : Load \(Item.fileName) from File")
                promise(.success(obj))
            }
            
            else {
                self.download(item: Item) { (result) in
                    switch result {
                    case .failure(let err):
                        print("[ImageLoader] : Error Download \(Item.fileName) => \(err.localizedDescription)")
                    case .success(_):
                        if let obj = self.retrieve(item: Item) {
                            self.cache.setObject(obj, forKey: NSString(string: Item.fileName))
                            print("[ImageLoader] : Load \(Item.fileName) from Remote")
                            promise(.success(obj))
                        } else {
                            print("[ImageLoader] : Cant read \(Item.fileName) file format")
                        }
                    }
                }
            }
            
        }
        return futur
    }
    
    func cleanCache() {
        self.cache.removeAllObjects()
    }
    
    func removeAllStorage() {
        
        let manager = FileManager.default
        
        let dir = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
        
        do {
            try manager.removeItem(at: dir)
        } catch let err {
            print(err.localizedDescription)
        }
    }
}

fileprivate extension DataLoader {
    
    enum Errors : Error {
        case missingStorageURL
        case fileIsNotStored
        case failingRetrieveData
        case isPending
    }
    
    func cache(item:LoaderItemProtocol) {
    
        if let object = self.retrieve(item: item) {
            self.cache.setObject(object, forKey: NSString(string: item.fileName))
        }
    }
    
    func couldDownload(request:URLRequest) -> Bool {

        guard self.requests.contains(request) else {
            self.requests.insert(request)
            return true
        }
        
        return false
    }
    
    func download(item:LoaderItemProtocol, Callback:@escaping (Result<URL,Error>) -> Void) {
        
        guard self.couldDownload(request: item.request) else {
            return Callback(.failure(Errors.isPending))
        }
        
        self.session.downloadTask(with: item.request) { (tmp, rep, err) in
            if let error = err {
                Callback(.failure(error))
            } else if let local = tmp {
                Callback(self.store(item: item, AtUrl: local))
            }
            self.requests.remove(item.request)
        }.resume()
    }
    
    func retrieve(item:LoaderItemProtocol) -> T? {
        
        let manager = FileManager.default
        
        let url = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.fileName)
        
        do {
            
            let data = try Data(contentsOf: url)
            return self.convertData(data)
            
        } catch {
            return nil
        }
    }
    
    func delete(item:LoaderItemProtocol) {
        
        let manager = FileManager.default
        
        let file = manager.urls(for: .applicationDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.fileName)
        
        if manager.fileExists(atPath: file.path) {
            try? manager.removeItem(at: file)
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
