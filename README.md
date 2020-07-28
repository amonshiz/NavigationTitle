# NavigationTitleView

Package to enable `titleView` with `navigationBarTitle` in SwiftUI

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
[Phone.app UI for Recents tab](Images/IMG_A66A35C991EA-1.jpeg)

## Solution

Use `UIViewRepresentable` to hook directly into the underlying UIKit objects
and insert the desired SwiftUI views into the top most navigation controller's
`navigationItem.titleView`. This ends up working okay. 
- When used on the root view controller, everything appears correctly
- When used with other view controllers on the navigation stack, the `titleView`'s content is not presented until the animation has settled, unclear why

## Issues
- As mentioned above, the view does not appear as expected *during* the animation of new view controllers onto the stack, but only after animation has completed
- The implementation makes assumptions that the content will always fit in whatever size is available using the `fixedSize()` modifier which then lets SwiftUI compress content to the intrinsic size. However, if that intrinsic size is greater than actually available, too bad.
- This is making use of a `UIViewRepresentable` view that then owns a `UIHostingController` and sticks *that* `view` into the `titleView` property, this is pretty silly
- Does not work with AppKit or watchOS yet
