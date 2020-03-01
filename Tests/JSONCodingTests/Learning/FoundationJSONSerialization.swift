import Foundation
import XCTest



class FoundationJSONSerialization: XCTestCase {
  
  #if canImport(Darwin)
  func testUnescapedNewLine() throws {
    do {
      let data = "{\"test\":\" \n \"}".data(using: .utf8)
      _ = try JSONSerialization.jsonObject(with: data!, options: [])
      XCTFail("Did not expect to reach this point")
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
  #endif
  
  #if canImport(Darwin)
  func testParsingOfLeadingZero() throws {
    do {
      let data = "{\"test\":01}".data(using: .utf8)
      _ = try JSONSerialization.jsonObject(with: data!, options: [])
      XCTFail("Did not expect to reach this point")
    }
    catch let error as NSError {
      XCTAssertEqual(error.domain, "NSCocoaErrorDomain")
      XCTAssertEqual(error.code, 3840)
      guard let debug = error.userInfo["NSDebugDescription"] as? String else {
        XCTFail("Expected to have an error debug description")
        return
      }
      XCTAssertEqual(debug, "Number with leading zero around character 9.")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  #endif
}


