import XCTest
@testable import PureSwiftJSONParsing

class StringParserTests: XCTestCase {
  
  func testSimpleHelloString() throws {
    var parser = JSONParserImpl(bytes: [UInt8](#""Hello""#.utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseString()
    XCTAssertEqual(result, "Hello")
  }

  #if false
  func testEscapedQuotesString() throws {
    var parser = JSONParserImpl(bytes: [UInt8](#""\\\"""#.utf8))
    _ = try XCTUnwrap(parser.reader.read())

    let result = try parser.parseString()
    XCTAssertEqual(result, #"\""#)
  }
  #endif
}
