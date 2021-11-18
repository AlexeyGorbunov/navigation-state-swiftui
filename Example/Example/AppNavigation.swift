//
//  AppNavigation.swift
//  Example
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI
import NavigationState

class AppNavigation: NavigationState<AppNavigation.State> {
    enum State: Equatable {
        case nextScene(scene: HashableAnyView)
        case nextView
        case yellow
        case blue
        case green
        case purple(number: Int)
        
        static func == (lhs: AppNavigation.State, rhs: AppNavigation.State) -> Bool {
            switch (lhs, rhs) {
            case (nextScene(let s1), nextScene(let s2)):
                return s1.id == s2.id
                
            case (purple(let n1), purple(let n2)):
                return n1 == n2
                
            default:
                return false
            }
        }
        
        
    }
}
