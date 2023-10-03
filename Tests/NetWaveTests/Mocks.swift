import Foundation
import NetWave

enum EndpointKinds {
  enum Test: EndpointKind {
    static func prepare(
      _ queryItems: [URLQueryItem]?
    ) -> [URLQueryItem]? {
      (queryItems ?? []) + [.init(name: "addedName", value: "addedValue")]
    }
  }
}

extension Endpoint where Kind == EndpointKinds.Test, Response == TestResult {
  static let testEndpoint: Self = {
    Endpoint(
      path: "/path",
      queryItems: [
        URLQueryItem(name: "name", value: "value")
      ],
      httpMethod: .post
    )
  }()
  
  static let brokenUrlEndpoint: Self = {
    Endpoint(path: "this is broken path")
  }()
}

final class MockURLSession: URLSessionProtocol {
  var dataResult: (Data, URLResponse) = (Data(), URLResponse())
  var dataError: Error?
  
  func data(
    for request: URLRequest,
    delegate: URLSessionTaskDelegate?
  ) async throws -> (Data, URLResponse) {
    if let dataError {
      throw dataError
    }
    return dataResult
  }
  
  struct Invocation {
    let request: URLRequest
    let delegate: URLSessionTaskDelegate?
  }
}

struct TestResult: Codable, Equatable {
  let text: String
}

extension URLResponse {
  static let success: URLResponse = {
    HTTPURLResponse(
      url: URL(string: "example.com")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!
  }()
  
  static let badResponse: URLResponse = {
    HTTPURLResponse(
      url: URL(string: "example.com")!,
      statusCode: 404,
      httpVersion: nil,
      headerFields: nil
    )!
  }()
}

extension DecodingError: Equatable {
  public static func == (lhs: DecodingError, rhs: DecodingError) -> Bool {
    lhs.localizedDescription == rhs.localizedDescription &&
    lhs.errorDescription == rhs.errorDescription &&
    lhs.failureReason == rhs.failureReason &&
    lhs.helpAnchor == rhs.helpAnchor &&
    lhs.recoverySuggestion == rhs.recoverySuggestion
  }
}
