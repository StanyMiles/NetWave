import Foundation

public protocol URLSessionProtocol {
  func data(
    for request: URLRequest,
    delegate: URLSessionTaskDelegate?
  ) async throws -> (Data, URLResponse)
}

extension URLSessionProtocol {
  public func data(
    for request: URLRequest,
    delegate: URLSessionTaskDelegate? = nil
  ) async throws -> (Data, URLResponse) {
    try await data(for: request, delegate: delegate)
  }
}

public extension URLSessionProtocol where Self == URLSession {
  static var shared: Self { URLSession.shared }
}

extension URLSession: URLSessionProtocol {}
