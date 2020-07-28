import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

public final class NavigationTitleViewImpl<Content>: UIView where Content: View{
  fileprivate var titleViewContent: UIHostingController<Content>?
  fileprivate var vcForNavigationItem: UIViewController?

  public override func didMoveToWindow() {
    if window != nil,
       vcForNavigationItem == nil {
      vcForNavigationItem = getNavItemVC()
    }
  }

  private func getNavItemVC() -> UIViewController? {
    // find the first parent view controller with a navigation bar
    var nextResponder: UIResponder? = self
    while nextResponder != nil {
      if let vc = nextResponder as? UIViewController,
         vc.navigationController != nil {
        return vc
      } else if let nb = nextResponder as? UINavigationBar,
                let nbdelegate = nb.delegate as? UINavigationController,
                let topVC = nbdelegate.topViewController {
        return topVC
      }

      nextResponder = nextResponder?.next
    }

    return nil
  }
}

public struct FixedSizeView<Content>: View where Content: View {
  let content: Content
  public var body: some View {
    content.fixedSize()
  }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct NavigationTitleView<Content>: UIViewRepresentable where Content: View {
  public typealias InnerContent = FixedSizeView<Content>

  let content: Content

  public init(content: Content) {
    self.content = content
  }

  public func makeUIView(context: Context) -> NavigationTitleViewImpl<InnerContent>  {
    NavigationTitleViewImpl<InnerContent>()
  }

  public func updateUIView(_ uiView: NavigationTitleViewImpl<InnerContent>, context: Context) {
    // only need to set stuff up if the view has found a parent view controller
    // with a navigation controller
    if let vc = uiView.vcForNavigationItem {
      // when SwiftUI updates the view structs the struct within the
      // UIHostingController will be out of date and not automatically updated,
      // thus it has to be manually replaced. the `TitleViewImpl` is simply a
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
