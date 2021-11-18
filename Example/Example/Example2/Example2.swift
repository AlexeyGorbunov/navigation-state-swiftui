//
//  Example2.swift
//  Example
//
//  Created by Alexey Gorbunov on 18.11.2021.
//

import SwiftUI
import Combine

struct Example2View: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Button("Yellow Sheet") {
                viewModel.navigation.show(type: .sheet, state: .yellow)
            }
            
            Button("Green FullScreen") {
                viewModel.navigation.show(type: .fullScreen, state: .green)
            }
            
            Button("Blue Push") {
                viewModel.navigation.show(type: .push, state: .blue)
            }
        }
        .onAppear(perform: viewModel.load)
        .onDisappear(perform: viewModel.cancel)
        .navigation(type: viewModel.navigation.presentType, item: $viewModel.navigation.state) { state in
            switch state {
            case .yellow:
                YellowView()
                
            case .green:
                GreenView()
                
            case .blue:
                BlueView { _ in
                    viewModel.navigation.dismiss()
                }
                
            default:
                EmptyView()
            }
        }
    }
}

extension Example2View {
    
    class ViewModel: ObservableObject {
        
        @Published var navigation = AppNavigation()
        
        var cancellable = Set<AnyCancellable>()
        
        func load() {
            navigation.observer(self.objectWillChange)
                .store(in: &cancellable)
        }
        
        func cancel() {
            //cancellable.removeAll()
        }
        
    }
}
