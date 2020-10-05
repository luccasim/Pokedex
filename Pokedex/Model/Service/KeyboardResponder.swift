//
//  KeyboardResponder.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI
import Combine

protocol KeyboardResponderProtocol {
    var currentHeight: CGFloat {get}
    var duration: TimeInterval {get}
}

final class KeyboardResponder: ObservableObject, KeyboardResponderProtocol {
    
    @Published var currentHeight: CGFloat = 0
    @Published var duration: TimeInterval = 0.3
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] in self?.keyboardNotification($0)})
            .store(in: &bag)
    }
    
    private func keyboardNotification(_ notification:Notification) {
        
        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        if let userInfo = notification.userInfo {
            
            self.duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            self.currentHeight = (isShowing) ? endFrame?.height ?? 0 : 0
            print(self.currentHeight)
            print(self.duration)
        }
    }
}
