//
//  HashableAnyView.swift
//  NavigationState
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI

struct HashableAnyView {
    let id: UUID
    let view: AnyView
    
    init(id: UUID = UUID(), _ view: AnyView) {
        self.id = id
        self.view = view
    }
}
