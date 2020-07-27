import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

private class NavigationTitleViewImpl<Content>: UIView where Content: View{
  fileprivate var titleViewContent: UIHostingController<Content>?
  fileprivate var vcForNavigationItem: UIViewController?

  override func didMoveToWindow() {
    if window != nil {
      vcForNavigationItem = getNavItemVC()
    } else {
      if let nivc = vcForNavigationItem,
         let tv = nivc.navigationItem.titleView,
         let tvc = titleViewContent,
         tv == tvc.view {
        nivc.navigationItem.titleView = nil
        vcForNavigationItem = nil
        titleViewContent = nil
      }
    }
  }

  deinit {
    print("Deinit")
  }

  private func getNavItemVC() -> UIViewController? {
    // find the first parent view controller with a navigation bar
    var nextResponder: UIResponder? = self
    while nextResponder != nil {
      if let vc = nextResponder as? UIViewController,
         vc.navigationController != nil {
        return vc
      }

      nextResponder = nextResponder?.next
    }

    return nil
  }
}

private struct FixedSizeView<Content>: View where Content: View {
  let content: Content
  var body: some View {
    content.fixedSize()
  }
}

private struct NavigationTitleView<Content>: UIViewRepresentable where Content: View {
  typealias InnerContent = FixedSizeView<Content>

  let content: Content

  init(content: Content) {
    self.content = content
  }

  func makeUIView(context: Context) -> NavigationTitleViewImpl<InnerContent> {
    NavigationTitleViewImpl<FixedSizeView<Content>>()
  }

  func updateUIView(_ uiView: NavigationTitleViewImpl<InnerContent>, context: Context) {
    // only need to set stuff up if the view has found a parent view controller
    // with a navigation controller
    if let vc = uiView.vcForNavigationItem {
      // when SwiftUI updates the view structs the struct within the
      // UIHostingController will be out of date and not automatically updated,
      // thus it has to be manually replaced. the `TitleViewImpl` is simpley a
      // place to store references and does not actually instantiate the
      // hosting controller so that there is only 1 canonical location to do so.
      if let tvc = uiView.titleViewContent {
        tvc.rootView = FixedSizeView(content: content)
      } else {
        uiView.titleViewContent = UIHostingController(rootView: FixedSizeView(content: content))
        vc.navigationItem.titleView = uiView.titleViewContent!.view
      }
    }
  }
}
#endif

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
  func navigationTitleView<Content>(@ViewBuilder _ content: () -> Content) -> some View where Content: View {
    #if os(iOS) || os(tvOS)
    return self.overlay(
      NavigationTitleView(content: content())
        // prevent SwiftUI from directing all touches to the `TitleView`
        // instance's underlying view, even if the `UIView` object that is created
        // because it is a `UIViewRepresentable` does not accept any touches.
        // can verify this by adding empty implementations of the methods
        // `point(inside:with:)` and `hitTest(_:with:)` to `TitleViewImpl`
        .allowsHitTesting(false)
    )
    #else
    return content()
    #endif
  }
}

