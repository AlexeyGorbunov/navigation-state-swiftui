//
//  HashableAnyView.swift
//  NavigationState
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI

public struct HashableAnyView {
    public let id: UUID
    public let view: AnyView
    
    public init(id: UUID = UUID(), _ view: AnyView) {
        self.id = id
        self.view = view
    }
}
