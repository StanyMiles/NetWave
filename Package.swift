// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NetWave",
  products: [
    .library(
      name: "NetWave",
      targets: ["NetWave"]),
  ],
  targets: [
    .target(
      name: "NetWave"),
    .testTarget(
      name: "NetWaveTests",
      dependencies: ["NetWave"]),
  ]
)
