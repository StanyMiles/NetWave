import NetWave
import XCTest

final class NetWaveTests: XCTestCase {
  private let session = MockURLSession()
  private lazy var netWave = NetWave(session: session)
  
  func test_loadData_throwsErrorOnInvalidResponse() async {
    do {
      _ = try await netWave.loadData(
        for: .brokenUrlEndpoint,
        host: .init(rawValue: "")
      )
    } catch {
      XCTAssertEqual(error as? NetWaveError, .invalidRequest)
    }
  }
  
  func test_loadData_throwsDataRequestError() async {
    let expectedError = NSError(domain: "test", code: 0)
    session.dataError = expectedError
    
    do {
      _ = try await netWave.loadData(
        for: .testEndpoint,
        host: .init(rawValue: "example.com")
      )
    } catch {
      XCTAssertEqual(error as NSError, expectedError)
    }
  }
  
  func test_loadData_throwsBadResponseError() async {
    session.dataResult = (Data(), .badResponse)
    
    do {
      _ = try await netWave.loadData(
        for: .testEndpoint,
        host: .init(rawValue: "example.com")
      )
    } catch {
      XCTAssertEqual(error as? NetWaveError, .badResponse)
    }
  }
  
  func test_loadData_returnsDecodedResult() async throws {
    let expectedResult = TestResult(text: "test result")
    let data = try JSONEncoder().encode(expectedResult)
    session.dataResult = (data, .success)
    
    let result = try await netWave.loadData(
      for: .testEndpoint,
      host: .init(rawValue: "example.com")
    )
    
    XCTAssertEqual(result, expectedResult)
  }
  
  func test_loadData_throwsDecodingError() async {
    session.dataResult = (Data(), .success)
    
    do {
      _ = try await netWave.loadData(
        for: .testEndpoint,
        host: .init(rawValue: "example.com")
      )
    } catch {
      XCTAssertEqual(
        error as? DecodingError,
        .dataCorrupted(.init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError: NSError(
            domain: "NSCocoaErrorDomain",
            code: 3840,
            userInfo: ["NSDebugDescription": "Unexpected end of file"]
          )
        ))
      )
    }
  }
}
