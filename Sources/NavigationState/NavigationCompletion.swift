//
//  NavigationCompletion.swift
//  NavigationState
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI

public typealias NavigationCompletion = ((NavigationCompletionItem)->Void) -> Void

public enum NavigationCompletionItem {
    case dismiss((()->Void)?)
    case push(scene: AnyView)
}
