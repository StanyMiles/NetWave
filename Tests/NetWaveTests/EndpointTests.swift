import NetWave
import XCTest

final class EndpointTests: XCTestCase {
  
  func test_makeRequest_returnsCorrectRequest() {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "example.com"
    components.path = "/path"
    components.queryItems = [
      URLQueryItem(name: "name", value: "value"),
      URLQueryItem(name: "addedName", value: "addedValue")
    ]
    
    var expectedRequest = URLRequest(url: components.url!)
    expectedRequest.httpMethod = "POST"
    
    let endoint: Endpoint = .testEndpoint
    
    XCTAssertEqual(
      endoint.makeRequest(
        host: .init(rawValue: "example.com")
      ),
      expectedRequest
    )
  }
  
  func test_makeRequest_returnsNilOnBrokenURL() {
    let endoint: Endpoint = .brokenUrlEndpoint
    
    XCTAssertNil(
      endoint.makeRequest(
        host: .init(rawValue: "not a url")
      )
    )
  }
}
