import XCTest
import SwiftUI
@testable import NavigationTitleView

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
final class NavigationTitleViewTests: XCTestCase {
  private func addToolbar<Content>(_ content: Content) -> some View where Content: View {
    #if os(iOS) || os(tvOS)
      return content
      .toolbar {
        ToolbarItem {
          NavigationTitleView(content: Text("Else"))
        }
      }
    #else
    return content
    #endif
  }

  func testExample() {
    let content =
      addToolbar(HStack { Text("Something") })
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
