import XCTest
@testable import PureSwiftJSONParsing

class JSONValueTests: XCTestCase {

  // MARK: - String tests -
  
  func testEncodeControlCharacters() {
    // All Unicode characters may be placed within the
    // quotation marks, except for the characters that MUST be escaped:
    // quotation mark, reverse solidus, and the control characters (U+0000
    // through U+001F).
    // https://tools.ietf.org/html/rfc7159#section-7
    
    for index in 0...31 {
      let controlCharacters = Unicode.Scalar(index)!
      let value = JSONValue.string("\(controlCharacters)")

      var bytes = [UInt8]()
      value.appendBytes(to: &bytes)
      
      let expected: [UInt8] = [
        UInt8(ascii: "\""),
        92,           // backslash to escape
        UInt8(index), // actual control character
        UInt8(ascii: "\"")
      ]
      
      XCTAssertEqual(bytes, expected)
    }
  }
  
  func testEncodeQuotationMark() {
    let value = JSONValue.string("\"")
    var bytes = [UInt8]()
    value.appendBytes(to: &bytes)
    
    let expected: [UInt8] = [
      UInt8(ascii: "\""),
      92,                 // backslash to escape
      UInt8(ascii: "\""), // actual quotation mark
      UInt8(ascii: "\"")
    ]
    
    XCTAssertEqual(bytes, expected)
  }
  
  func testEncodeReverseSolidus() {
    let value = JSONValue.string("\\")
    var bytes = [UInt8]()
    value.appendBytes(to: &bytes)
    
    let expected: [UInt8] = [
      UInt8(ascii: "\""),
      92,                 // backslash to escape
      UInt8(ascii: "\\"), // actual reverse solidus
      UInt8(ascii: "\"")
    ]
    
    XCTAssertEqual(bytes, expected)
  }
  
  func testEmojiAvocado() {
    let value = JSONValue.string("🥑")
    var bytes = [UInt8]()
    value.appendBytes(to: &bytes)
    XCTAssertEqual(bytes, [UInt8](#""🥑""#.utf8))
  }
  
  func testEmojiFamily() {
    let value = JSONValue.string("👩‍👩‍👧‍👧")
    var bytes = [UInt8]()
    value.appendBytes(to: &bytes)
    XCTAssertEqual(bytes, [UInt8](#""👩‍👩‍👧‍👧""#.utf8))
  }
}
