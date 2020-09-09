//
//  WebServiceHelper.swift
//  Pokedex
//
//  Created by owee on 08/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine

protocol WebServiceHelper {
    
    var session : URLSession {get}
    
    func dataTask(Request:URLRequest, Completion:@escaping ((Result<Data,Error>) -> Void))
    
    func listTask(Option:WebService.Option, List:[URLRequest],
                  Completion:@escaping ((Result<(URLRequest, Data),Error>) -> Void),
                  OnFinish:@escaping ((Int) -> Void))
    
}

class WebService: WebServiceHelper {
        
    private(set) var session : URLSession
    
    init(Session:URLSession) {
        self.session = Session
    }
    
    enum APIErrors : Error {
        case requestIsAlreadyTask
    }
    
    enum Option {
        case Simultaneous
        case Order
        case Page(Page:Int)
        case Timer(Page:Int,Interval:TimeInterval)
    }

    func listTask(Option:WebService.Option = .Order, List:[URLRequest], Completion:@escaping ((Result<(URLRequest, Data),Error>) -> Void), OnFinish:@escaping ((Int) -> Void)) {
        
        switch Option {
        case .Simultaneous:
            self.listTask(Limit: 0, Time: 0, List: List, Completion: Completion, OnFinish: OnFinish)
        case .Order:
            self.listTask(Limit: 1, Time: 0, List: List, Completion: Completion, OnFinish: OnFinish)
        case .Page(Page: let limit):
            self.listTask(Limit: limit, Time: 0, List: List, Completion: Completion, OnFinish: OnFinish)
        case .Timer(Page: let limit, Interval: let time):
            self.listTask(Limit: limit, Time: time, List: List, Completion: Completion, OnFinish: OnFinish)
        }
    }
    
    private let listQueue = DispatchQueue(label: "List Queue")
    private let group = DispatchGroup()
    private(set) var isProcess = false
    
    private func listTask(Limit:Int, Time:TimeInterval, List:[URLRequest], Completion:@escaping ((Result<(URLRequest, Data),Error>) -> Void), OnFinish:@escaping ((Int) -> Void)) {
                
        self.listQueue.async {
            
            guard self.isProcess else {
                return OnFinish(0)
            }
            
            self.isProcess = true
            
            let limit = Limit == 0 ? List.count : Limit
            
            // Remove duplicates
            var dict = [URLRequest:Bool]()
            var list = List.filter({dict.updateValue(true, forKey: $0) == nil})
            
            var success = 0
                        
            while (!list.isEmpty) {
                
                let page = (0..<limit).compactMap { _ in
                    return list.isEmpty ? nil : list.removeFirst()
                }
                                
                if Time > 0 {
                    
                    let timer = DispatchQueue.init(label: "Timer \(list.count)")
                    
                    timer.async {
                        print("Time start : \(Date())")
                        self.group.enter()
                    }
                    
                    timer.asyncAfter(deadline: .now() + Time) {
                        print("Time end: \(Date())")
                        self.group.leave()
                    }
                }
                
                page.forEach { (request) in
                    
                    self.group.enter()
                    
                    DispatchQueue.init(label: "\(request)").async {
                        
                        self.dataTask(Request: request) { (res) in
                            
                            switch res {
                            case .success(let data):
                                success += 1
                                Completion(.success((request, data)))
                            case .failure(let error):
                                Completion(.failure(error))
                            }
                            
                            self.group.leave()
                        }
                    }
                }
                
                self.group.wait()
            }
            
            self.group.notify(queue: .main) {
                OnFinish(success)
                self.isProcess = false
            }
        }
    }
    
    private var requests = Set<URLRequest>()
    private var requestQueue = DispatchQueue(label: "Download Queue")
    
    func dataTask(Request: URLRequest, Completion: @escaping ((Result<Data, Error>) -> Void)) {
        
        self.requestQueue.async {
            
            print("Start")
            
            guard !self.requests.contains(Request) else {
                return Completion(.failure(APIErrors.requestIsAlreadyTask))
            }
            
            self.session.dataTask(with: Request) { [weak self] (Data, Rep, Error) in
                
                if let error = Error {
                    Completion(.failure(error))
                }
                    
                else if let data = Data {
                    Completion(.success(data))
                }
                
                let _ = self?.requestQueue.sync {
                    self?.requests.remove(Request)
                }
                print("Stop")
                
            }.resume()
            
            self.requests.insert(Request)
        }
    }
}
