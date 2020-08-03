//
//  Logging.swift
//  
//
//  Created by Andrew Monshizadeh on 7/29/20.
//

import Foundation

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct NavigationTitleViewLogging {
  static var isEnabled = false

  static func log(_ object: @autoclosure () -> Any) {
    if isEnabled {
      print("[NavigationTitleView] \(object())")
    }
  }
}
