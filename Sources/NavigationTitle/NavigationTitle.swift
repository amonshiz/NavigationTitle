//
//  NavigationTitle.swift
//  
//
//  Created by Andrew Monshizadeh on 7/28/20.
//

import SwiftUI

#if canImport(UIKit)

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

    NavigationControllerDelegate.mapping[namespace]?.title = title
  }

  var body: some View {
    AnyView(
      CurrentViewControllerTitleSetter(title: title)
        .allowsHitTesting(false)
        .frame(width: 0, height: 0, alignment: .center)
    )
  }
}

#endif // canImport(UIKit)

@available(iOS 14.0, OSX 11.0, tvOS 14.0, watchOS 7.0, *)
public extension View {
  func navigationTitle(_ title: String, within namespace: Namespace.ID) -> some View {
    #if canImport(UIKit)
    return self.background(TitleSetter(within: namespace, title: title))
    #else
    return self
    #endif
  }

  func rootNavigationBarIdentified(within namespace: Namespace.ID) -> some View {
    #if canImport(UIKit)
    return self.background(RootNavigationBarFinder(within: namespace))
    #else
    return self
    #endif
  }
}
