import Foundation
import XCTest

class  FondationJSONSerialization: XCTestCase {
  
  func testUnescapedNewLine() throws {
    do {
      let data = "{\"test\":\" \n \"}".data(using: .utf8)
      _ = try JSONSerialization.jsonObject(with: data!, options: [])
    }
    catch let error as NSError {
      XCTAssertEqual(error.domain, "NSCocoaErrorDomain")
      XCTAssertEqual(error.code, 3840)
      guard let debug = error.userInfo["NSDebugDescription"] as? String else {
        XCTFail("Expected to have an error debug description")
        return
      }
      XCTAssertEqual(debug, "Unescaped control character around character 10.")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
