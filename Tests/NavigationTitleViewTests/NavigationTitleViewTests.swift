import XCTest
import SwiftUI
@testable import NavigationTitleView

final class NavigationTitleViewTests: XCTestCase {
  func testExample() {
    let content =
      HStack {
        Text("Something")
      }
      .navigationTitleView{
        Text("Else")
      }
    let contentMirror = Mirror(reflecting: content)

    #if os(iOS) || os(tvOS)
    XCTAssertTrue(contentMirror.description.contains("NavigationTitleView"))
    #else
    XCTAssertFalse(contentMirror.description.contains("NavigationTitleView"))
    #endif
  }

    static var allTests = [
        ("testExample", testExample),
    ]
}
