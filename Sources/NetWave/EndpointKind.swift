import Foundation

public protocol EndpointKind {
  static func prepare(
    _ queryItems: [URLQueryItem]?
  ) -> [URLQueryItem]?
}
