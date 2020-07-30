//
//  NavigationBarFinder.swift
//  
//
//  Created by Andrew Monshizadeh on 7/29/20.
//

import SwiftUI

#if os(iOS) || os(tvOS)

import UIKit

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
class NavigationBarFindingViewController: UIViewController {
  let namespace: Namespace.ID

  init(within namespace: Namespace.ID) {
    self.namespace = namespace

    let wrapper = RootNavigationBarFinder.namespaceToInterposer[namespace, default: InterposeWrapper()]
    RootNavigationBarFinder.namespaceToInterposer[namespace] = wrapper

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let navcontroller = navigationController,
       let wrapper = RootNavigationBarFinder.namespaceToInterposer[namespace] {
      wrapper.navigationController = navcontroller
    }
  }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct RootNavigationBarFinder: UIViewControllerRepresentable {
  static var namespaceToInterposer: [Namespace.ID: InterposeWrapper] = [:]

  let namespace: Namespace.ID
  init(within: Namespace.ID) {
    self.namespace = within

    guard let wrapper = RootNavigationBarFinder.namespaceToInterposer[self.namespace] else { return }
    if wrapper.hasBeenBuiltAtLeastOnce {
      wrapper.removeTitlesFromLastBuild()
    }

    wrapper.markBuildComplete()
  }

  func makeUIViewController(context: Context) -> NavigationBarFindingViewController {
    return NavigationBarFindingViewController(within: namespace)
  }

  func updateUIViewController(_ uiViewController: NavigationBarFindingViewController, context: Context) { }
}

#endif
