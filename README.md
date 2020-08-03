# NavigationTitle

Package that lets a `navigationTitle` and a `ToolbarItemPlacement.principal` work together

Make your dreams come true!
![PhoneRecentsTab](./Images/IMG_A66A35C991EA-1.jpeg)

## Installation

### Another Swift package
Add to your `Package.swift` file
```
let package = Package(
  ...
  dependencies = [
    .package(url: "https://github.com/amonshiz/NavigationTitle.git", Package.Dependency.Requirement.branch("main")),
    ...
  ],
  targets = [
    .target(
      name: "YourTarget",
      dependencies: ["NavigationTitle", …],
      ...),
    ...
  ]
)
```

### Add to an app
- File -> Swift Packages -> Add Package Dependency ...
- `https://github.com/amonshiz/NavigationTitle.git`
- Track the `main` branch (I make no promises on keeping tags up to date)

## Usage

```swift
import SwiftUI
import NavigationTitle

struct ContentView: View {
  @Namespace var aNamespace // required

  var body: some View {
    NavigationView {
      // Does not need to be a list, but this is does demonstrate the `.large`
      // style title behaviors best
      List {
        Text("Hello, world").padding()
      }
      // Used in the same place the usual `.navigationTitle(_)` or
      // `.navigationBarTitle(_)` would be used
      .navigationTitle("A Great Title", within: aNamespace)
    }
    // Should be used *on* the navigation stack to track
    .rootNavigationBarIdentified(within: aNamespace)
  }
}
```

### Notes
- It is best practice to place the `.navigationTitle(_:within:)` as close to the top level of each view as possible. Ideally it is applied to the view that is a direct child of `NavigationView`.
- It is best practice to use separate `View` types as the `destination` for a `NavigationLink` as opposed to defining the destination inline. This ensures that the order of evaluating the `View.body` property matches the order that they will be displayed.
- You *can* mix and match the system `.navigationTitle()` with this, it has been tested but there may be edges cases. If so please submit an Issue!

## Problem

In SwiftUI there is the convenient `toolbar` and `toolbarItem` APIs that allow
the developer to add content to toolbars and navigation bars easily and to 
define the semantics of where that content should appear within the bar.
Additionally, SwiftUI makes it extremely easy to change the navigation title
display mode with `navigationBarTitleDisplayMode`. However, there is at least
one conflict between the display mode and toolbar item API: with a `large` or
`automatic` display mode any content put in the `principal` placement will not
be displayed at all.

The use case is something like the "Recents" tab in the Phone.app UI.
![Phone.app UI for Recents tab](Images/IMG_A66A35C991EA-1.jpeg)

## Solution

Use `UIViewConrollerRepresentable` to hook directly into the underlying UIKit 
objects and insert the desired text into the view controller and its attendant
`navigationItem`. In this case the package is replacing the 
`UINavigationControllerDelegate` instance in the "root" navigation controller 
with an internal implementation that sets the `title` on any pushed view 
controller that doesn't already have a title and it's `navigationItem`. This 
internal delegate also maintains a `weak` reference to any existing delegate 
and will forward all messages along to it as necessary.

## Issues
- Does not work with AppKit or watchOS yet
- There is a bug in SwiftUI that causes an `[Assert]` to fire after pushing two views onto a navigation stack ([feedback documented here](https://github.com/amonshiz/feedback-examples/blob/main/README.md#displaymodebuttonissue)) so just know that isn't caused by this!
