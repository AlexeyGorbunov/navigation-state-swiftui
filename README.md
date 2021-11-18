# NavigationState

## Installation

### Swift Package Manager

```
https://github.com/alexflm/navigation-state-swiftui
```

## Setup
First you need to create an AppNavigation class, which will store all your scenes.

```swift
class AppNavigation: NavigationState<AppNavigation.State> {
    enum State: Equatable {
        case paywallPLUS
        case messages
        case profile
        case photo(data: Photo)
        case nextScene(scene: HashableAnyView)
        //nextScene is needed so that you can create Flow from several scenes, where the future scene is not known in advance.
        
        static func == (lhs: AppNavigation.State, rhs: AppNavigation.State) -> Bool {
            switch (lhs, rhs) {
            case (nextScene(let s1), nextScene(let s2)):
                return s1.id == s2.id
                
            case (photos(let p1), photos(let p2)):
                return p1.id == p1.id
                
            default:
                return false
            }
        }
    }
}

```

## Usage with View
1. Initialize navigation. You need to initialize an object for every scene.
```swift
@StateObject var navigation = AppNavigation()
```
2. Add modifier `navigation`
```swift
VStack {
  ...
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
```
3. There are 2 ways to create a dismiss from a `childView`. 

The first option is basic.
```swift
@Environment(\.dismiss) var dismiss
```
You can also dismiss from the root view using `navigation`.
```swift
navigation.dismiss()
```

## Usage with ViewModel
If you want to initialize navigation in the viewModel, you need to add an observer so that the view model can notify the view of changes.

```swift
class ViewModel: ObservableObject {
        
    @Published var navigation = AppNavigation()
    var cancellable = Set<AnyCancellable>()
    
    // The load function must be called in the onAppear of the view.
    func load() {
        navigation.observer(self.objectWillChange)
            .store(in: &cancellable)
    }        
}
```

## Flow
A flexible option is to create a view, where the view is not dependent on other views.

In order to create your own Flows, you need to add `completion` to the view.
```swift
var completion: NavigationCompletion
```

By clicking on the button, you set the navigation options.
```swift
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
```

### Example flow
```swift
func progressFlow(data: Progress, allowAd: Bool, navigationCompletion: @escaping NavigationCompletion) -> some View {
    self.progressView(data: data) {
        if allowAd, !UserDefaults.isPlusVersion {
            $0(.push(scene: AnyView(self.makeFullScreenAdNativeView(navigationCompletion: navigationCompletion))))
        } else {
            navigationCompletion($0)
        }
    }
}
```


## License
This library is released under the MIT license. See [LICENSE](LICENSE) for details.
