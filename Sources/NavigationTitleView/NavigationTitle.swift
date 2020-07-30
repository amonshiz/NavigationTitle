//
//  NavigationTitle.swift
//  
//
//  Created by Andrew Monshizadeh on 7/28/20.
//

import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
class ParentTitleSetting: UIViewController {
  func update(title: String) {
    self.title = title
    parent?.title = title
  }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct CurrentViewControllerTitleSetter: UIViewControllerRepresentable {
  let title: String

  func makeUIViewController(context: Context) -> ParentTitleSetting {
    return ParentTitleSetting()
  }

  func updateUIViewController(_ uiViewController: ParentTitleSetting, context: Context) {
    uiViewController.update(title: title)
  }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct TitleSetter: View {
  let title: String

  init(within namespace: Namespace.ID, title: String) {
    self.title = title

    let wrapper = RootNavigationBarFinder.namespaceToInterposer[namespace, default: InterposeWrapper()]
    wrapper.addTitle(title)
    RootNavigationBarFinder.namespaceToInterposer[namespace] = wrapper
  }

  var body: some View {
    CurrentViewControllerTitleSetter(title: title)
      .allowsHitTesting(false)
      .frame(width: 0, height: 0, alignment: .center)
  }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public extension View {
  func navigationTitle(_ title: String, within namespace: Namespace.ID) -> some View {
    self.background(TitleSetter(within: namespace, title: title))
  }

  func rootNavigationBarIdentified(within namespace: Namespace.ID) -> some View {
    self.background(RootNavigationBarFinder(within: namespace))
  }
}
#endif
