//
//  LazyView.swift
//  NavigationState
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI

public struct LazyView<Content: View>: View {
    let build: () -> Content
    
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    public var body: Content {
        build()
    }
}

