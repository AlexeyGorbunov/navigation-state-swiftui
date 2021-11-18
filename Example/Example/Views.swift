//
//  Components.swift
//  Example
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI
import NavigationState

struct GreenView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}

struct YellowView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}

struct BlueView: View {
    
    @Environment(\.dismiss) var dismiss
    var completion: NavigationCompletion
    
    @StateObject var navigation = AppNavigation()
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            Button("Dismiss") {
                completion { state in
                    switch state {
                    case .dismiss(let completion):
                        completion?()
                        
                    case .push(let scene):
                        navigation.show(type: .push, state: .nextScene(scene: .init(scene)))
                    }
                }
            }
        }
        .navigation(type: navigation.presentType, item: $navigation.state) {
            presentView(state: $0)
        }
    }
    
    @ViewBuilder
    func presentView(state: AppNavigation.State?) -> some View {
        switch state {
        case .nextScene(let scene):
            scene.view
            
        default:
            EmptyView()
        }
    }
}
