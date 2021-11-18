//
//  Example1.swift
//  Example
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI

struct Example1View: View {
    
    @StateObject var navigation = AppNavigation()
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Button("Yellow Sheet") {
                navigation.show(type: .sheet, state: .yellow)
            }
            
            Button("Green FullScreen") {
                navigation.show(type: .fullScreen, state: .green)
            }
            
            Button("Blue Push") {
                navigation.show(type: .push, state: .blue)
            }
        }
        .navigation(type: navigation.presentType, item: $navigation.state) { state in
            switch state {
            case .yellow:
                YellowView()
                
            case .green:
                GreenView()
                
            case .blue:
                BlueView { _ in
                    navigation.dismiss()
                }
                
            default:
                EmptyView()
            }
        }
    }
}
