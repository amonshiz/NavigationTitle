import XCTest
import SwiftUI
@testable import NavigationTitle

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
final class NavigationTitleTests: XCTestCase {
  @Namespace var test
  private func addToolbar<Content>(_ content: Content) -> some View where Content: View {
    return content
      .toolbar {
        ToolbarItem(placement: .principal) {
          Picker(selection: .constant(1), label: Text("Picker")) {
            Text("First").tag(1)
            Text("Second").tag(2)
          }
        }
      }
  }

  func test_RootBarFinder() {
    let content =
      NavigationView {
        addToolbar(
          HStack {
            Text("Something")
          }
        )
      }
      .rootNavigationBarIdentified(within: test)
    let contentMirror = Mirror(reflecting: content)

    #if canImport(UIKit)
    XCTAssertTrue(contentMirror.description.contains("RootNavigationBarFinder"))
    #else // !canImport(UIKit)
    XCTAssertFalse(contentMirror.description.contains("RootNavigationBarFinder"))
    #endif
  }

  func test_TitleSetterAdded() {
    let content =
      NavigationView {
        addToolbar(
          HStack {
            Text("Something")
          }
        )
        .navigationTitle("TEST", within: test)
      }
      .rootNavigationBarIdentified(within: test)
    let contentMirror = Mirror(reflecting: content)

    #if canImport(UIKit)
    XCTAssertTrue(contentMirror.description.contains("TitleSetter"))
    #else // !canImport(UIKit)
    XCTAssertFalse(contentMirror.description.contains("TitleSetter"))
    #endif
  }

  static var allTests = [
    ("test_RootBarFinder", test_RootBarFinder),
    ("test_TitleSetterAdded", test_TitleSetterAdded),
  ]
}
