import XCTest
@testable import PureSwiftJSONParsing

class StringParserTests: XCTestCase {
  
  func testSimpleHelloString() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\"Hello\"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseString()
    XCTAssertEqual(result, "Hello")
  }
  
  func testEscapedQuotesString() throws {
    let bytes = [
      UInt8(ascii: "\""),
      UInt8(ascii: "\\"),
      UInt8(ascii: "\\"),
      UInt8(ascii: "\\"),
      UInt8(ascii: "\""),
      UInt8(ascii: "\""),
    ]
    var parser = JSONParserImpl(bytes: bytes)
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseString()    
    XCTAssertEqual([UInt8](result.utf8), [UInt8(ascii: "\\"), UInt8(ascii: "\"")])
  }
  
  
}
