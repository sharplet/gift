// swift-tools-version:5.2

import PackageDescription

extension Target.Dependency {
  static var argumentParser: Target.Dependency {
    .product(name: "ArgumentParser", package: "swift-argument-parser")
  }
}

let package = Package(
  name: "gift",
  products: [
    .executable(name: "gift", targets: ["gift"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.1.0"),
    .package(url: "https://github.com/sharplet/SwiftIO.git", from: "0.2.0"),
  ],
  targets: [
    .target(name: "gift", dependencies: [.argumentParser, "SwiftIO"]),
  ]
)
