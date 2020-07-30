//
//  InterposeWrapper.swift
//  
//
//  Created by Andrew Monshizadeh on 7/29/20.
//

import SwiftUI

#if os(iOS) || os(tvOS)

import InterposeKit

@available(iOS 14.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
class InterposeWrapper {
  private var titles: [String] = [""]

  private(set) var hasBeenBuiltAtLeastOnce: Bool = false
  private var buildCompleteCount: Int = 1 // always has filler at beginning

  weak var navigationController: UINavigationController? {
    didSet {
      guard let navigationController = navigationController else { return }
      let navigationBar = navigationController.navigationBar

      if pushHook == nil {
        do {
          self.pushHook = try navigationBar.hook(#selector(UINavigationBar.pushItem(_:animated:))) { (store: TypedHook
          <@convention(c) (UINavigationBar, Selector, UINavigationItem, Bool) -> Void,
           @convention(block) (UINavigationBar, UINavigationItem, Bool) -> Void>) in { [weak self] (navbar, navitem, animated) in
            self?.pushTitle(with: navbar, to: navitem)
            store.original(navbar, store.selector, navitem, animated)
           }
          }
        } catch {
          NavigationTitleViewLogging.log("Error setting up pushHook: \(error)")
        }

        if shouldPopHook == nil {
          do {
            if let delegate = navigationBar.delegate as? NSObject {
              self.shouldPopHook = try delegate.hook(#selector(UINavigationBarDelegate.navigationBar(_:shouldPop:))) { (store: TypedHook
              <@convention(c) (AnyObject, Selector, UINavigationBar, UINavigationItem) -> Bool,
               @convention(block) (AnyObject, UINavigationBar, UINavigationItem) -> Bool>) in { [weak self] (del, bar, item) in
                let should = store.original(del, store.selector, bar, item)
                if should {
                  self?.willPopTitle(with: bar)
                }
                return should
               }
              }
            }
          } catch {
            NavigationTitleViewLogging.log("Error setting up shouldPopHook: \(error)")
          }
        }
      }
    }
  }

  private var pushHook: AnyHook?
  private var shouldPopHook: AnyHook?

  deinit {
    do {
      _ = try pushHook?.revert()
      _ = pushHook?.cleanup()
      _ = try shouldPopHook?.revert()
      _ = shouldPopHook?.cleanup()

      navigationController = nil
    } catch {
      NavigationTitleViewLogging.log("Error tearing down wrapper: \(error)")
    }
  }

  private func pushTitle(with navbar: UINavigationBar, to item: UINavigationItem ) -> Void {
    let count = navbar.items?.count ?? 1

    if item.title != nil {
      // already set so let it be and added to the stack just for tracking
      titles.insert(item.title!, at: count)
      return
    }

    guard titles.count >= count else { return }
    item.title = titles[count]
  }

  private func willPopTitle(with navbar: UINavigationBar) -> Void {
  }

  private func resizeTitles(to count: Int) -> Void {
  }

  func addTitle(_ title: String) {
    titles.insert(title, at: 1)
  }

  func markBuildComplete() {
    buildCompleteCount = titles.count
    hasBeenBuiltAtLeastOnce = true
  }

  func removeTitlesFromLastBuild() {
    titles = Array(titles[0..<titles.count - (buildCompleteCount - 1)])
  }
}

#endif
