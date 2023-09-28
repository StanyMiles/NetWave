import Foundation

public struct Endpoint<Kind: EndpointKind, Response: Decodable> {
  public let path: String
  public let queryItems: [URLQueryItem]?
  public let httpMethod: HTTPMethod
  
  public init(
    path: String,
    queryItems: [URLQueryItem]? = nil,
    httpMethod: HTTPMethod = .get
  ) {
    self.path = path
    self.queryItems = queryItems
    self.httpMethod = httpMethod
  }
}

extension Endpoint {
  public func makeRequest(
    host: URLHost
  ) -> URLRequest? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host.rawValue
    components.path = path
    components.queryItems = Kind.prepare(queryItems)
    
    guard let url = components.url else {
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue.uppercased()
    return request
  }
}
