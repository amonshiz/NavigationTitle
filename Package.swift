// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NavigationTitleView",
  platforms: [
    .iOS(.v13), .tvOS(.v13), .macOS(.v10_13)
  ],
  products: [
    .library(
      name: "NavigationTitleView",
      targets: ["NavigationTitleView"]),
  ],
  dependencies: [
    .package(url: "https://github.com/steipete/InterposeKit.git", Package.Dependency.Requirement.branch("master"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "NavigationTitleView",
      dependencies: ["InterposeKit"]),
    .testTarget(
      name: "NavigationTitleViewTests",
      dependencies: ["NavigationTitleView"])
  ]
)
