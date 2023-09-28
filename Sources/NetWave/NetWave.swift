import Foundation

public enum NetWaveError: Error {
  case badResponse
  case invalidRequest
}

public protocol HTTPHandling {
  func loadData<Kind: EndpointKind, Response: Decodable>(
    for endpoint: Endpoint<Kind, Response>,
    host: URLHost
  ) async throws -> Response
}

public struct NetWave: HTTPHandling {
  private let session: URLSessionProtocol
  private let decoder: JSONDecoder
  
  public init(
    session: URLSessionProtocol = .shared,
    decoder: JSONDecoder = .init()
  ) {
    self.session = session
    self.decoder = decoder
  }
  
  public func loadData<Kind: EndpointKind, Response: Decodable>(
    for endpoint: Endpoint<Kind, Response>,
    host: URLHost
  ) async throws -> Response {
    guard let request = endpoint.makeRequest(host: host) else {
      throw NetWaveError.invalidRequest
    }
    
    let (data, response) = try await session.data(for: request)
    
    switch response.code {
      case 200...299:
        // Good response
        break
      default:
        throw NetWaveError.badResponse
    }
    
    return try decoder.decode(Response.self, from: data)
  }
}

private extension URLResponse {
  var code: Int {
    guard let httpResponse = self as? HTTPURLResponse else {
      fatalError("URLResponse is not HTTPURLResponse")
    }
    return httpResponse.statusCode
  }
}
