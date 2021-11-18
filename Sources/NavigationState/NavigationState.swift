import SwiftUI
import Combine

open class NavigationState<State: Equatable>: ObservableObject {
    
    @Published public var presentType: NavigationType?
    @Published public var state: State? {
        didSet {
            if state == nil {
                presentType = nil
            }
        }
    }
    
    public init() { }
    
    public func observer(_ publisher: ObjectWillChangePublisher) -> AnyCancellable {
        self.objectWillChange.receive(on: RunLoop.main, options: nil)
            .sink { (value) in
                publisher.send()
            }
    }
    
    public func show(type: NavigationType, state: State) {
        self.presentType = type
        self.state = state
    }
    
    public func dismiss() {
        self.state = nil
    }
}

extension NavigationLink where Label == EmptyView {
    init<Value>(item: Binding<Value?>, @ViewBuilder destination: (Value?) -> Destination) {
        let isActive = Binding<Bool> (
            get: { return item.wrappedValue != nil ? true : false },
            set: { if !$0 { item.wrappedValue = nil } }
        )
        
        self.init(isActive: isActive, destination: { destination(item.wrappedValue) }, label: EmptyView.init)
    }
}

extension View {
    public func navigation<Destination: View>(isActive: Binding<Bool>, destination: @escaping () -> Destination) -> some View {
        background(
            NavigationLink(destination: LazyView<Destination>(destination()), isActive: isActive, label: EmptyView.init)
            // NavigationLink<EmptyView, Destination>(isActive: isActive, destination: LazyView(destination), label: EmptyView.init)
        )
    }
}

extension View {
    func sheet<Value, Content: View>(
        item: Binding<Value?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value?) -> Content
    ) -> some View {
        let isActive = Binding<Bool> (
            get: { return item.wrappedValue != nil ? true : false },
            set: { if !$0 { item.wrappedValue = nil } }
        )
        
        return self.sheet(isPresented: isActive, onDismiss: onDismiss, content: { content(item.wrappedValue) })
    }
    
    @available(iOS 14, watchOS 7, tvOS 14, macCatalyst 14, *)
    @available(macOS, unavailable)
    func fullScreenCover<Value, Content: View>(
        item: Binding<Value?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value?) -> Content
    ) -> some View {
        let isActive = Binding<Bool> (
            get: { return item.wrappedValue != nil ? true : false },
            set: { if !$0 { item.wrappedValue = nil } }
        )
        return self.fullScreenCover(isPresented: isActive, onDismiss: onDismiss, content: { content(item.wrappedValue) })
    }
}

struct NavigationViewModifier<Value, Child: View>: ViewModifier {
    
    let type: NavigationType?
    let item: Binding<Value?>
    let onDismiss: (() -> Void)?
    let childView: (Value?) -> Child
    
    let pushItem: Binding<Value?>
    let sheetItem: Binding<Value?>
    let fullScreenItem: Binding<Value?>
    
    init(
        type: NavigationType?,
        item: Binding<Value?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder child: @escaping (Value?) -> Child
    ) {
        self.type = type
        self.item = item
        self.onDismiss = onDismiss
        self.childView = child
        
        self.pushItem = type == .push ? item : .constant(nil)
        self.sheetItem = type == .sheet ? item : .constant(nil)
        self.fullScreenItem = type == .fullScreen ? item : .constant(nil)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
        }
        .background(
            ZStack {
                NavigationLink(item: pushItem, destination: childView)
                
                Color.clear
                    .sheet(item: sheetItem, onDismiss: onDismiss, content: childView)
                
                #if os(macOS)
                Color.clear
                    .sheet(item: fullScreenItem, onDismiss: onDismiss, content: childView)
                #else
                Color.clear
                    .fullScreenCover(item: fullScreenItem, onDismiss: onDismiss, content: childView)
                #endif
            }
        )
    }
}

extension View {
    public func navigation<Value, Child: View>(
        type: NavigationType?,
        item: Binding<Value?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder child: @escaping (Value?) -> Child
    ) -> some View {
        self.modifier(NavigationViewModifier(type: type, item: item, onDismiss: onDismiss, child: child))
    }
}

