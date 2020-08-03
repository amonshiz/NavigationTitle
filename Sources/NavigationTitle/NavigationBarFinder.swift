//
//  NavigationBarFinder.swift
//  
//
//  Created by Andrew Monshizadeh on 7/29/20.
//

import SwiftUI

#if canImport(UIKit)

import UIKit

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
  static var mapping: [Namespace.ID: NavigationControllerDelegate] = [:]

  private weak var wrappedDelegate: UINavigationControllerDelegate?

  init(wrapping delegate: UINavigationControllerDelegate?) {
    self.wrappedDelegate = delegate
  }

  var title: String?
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if let t = title,
       viewController.title == nil {
      viewController.navigationItem.title = t
      viewController.title = t
    }
    title = nil

    wrappedDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
  }

  override func responds(to aSelector: Selector!) -> Bool {
    if #selector(navigationController(_:willShow:animated:)) == aSelector {
      return true
    }

    return wrappedDelegate?.responds(to: aSelector) ?? false
  }

  override func forwardingTarget(for aSelector: Selector!) -> Any? {
    if #selector(navigationController(_:willShow:animated:)) == aSelector {
      return self
    }

    return wrappedDelegate
  }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
class NavigationBarFindingViewController: UIViewController {
  let namespace: Namespace.ID

  init(within namespace: Namespace.ID) {
    self.namespace = namespace
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let navcontroller = navigationController {
      let delegate = NavigationControllerDelegate(wrapping: navcontroller.delegate)
      navcontroller.delegate = delegate
      NavigationControllerDelegate.mapping[namespace] = delegate
    }
  }
}

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct RootNavigationBarFinder: UIViewControllerRepresentable {
  let namespace: Namespace.ID
  init(within namespace: Namespace.ID) {
    self.namespace = namespace
  }

  func makeUIViewController(context: Context) -> NavigationBarFindingViewController {
    return NavigationBarFindingViewController(within: namespace)
  }

  func updateUIViewController(_ uiViewController: NavigationBarFindingViewController, context: Context) { }
}

#endif // canImport(UIKit)
