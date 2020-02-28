import XCTest
@testable import PureSwiftJSONParsing

class NullParserTests: XCTestCase {
  
  func testSimpleNull() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("null".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    try parser.parseNull()
  }
  
  func testMiddleCharacterInvalidCase() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("nuLl".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    do {
      try parser.parseNull()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "L")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testNullMissingEnd() throws {
    do {
      _ = try JSONParser().parse(bytes: [UInt8]("nul".utf8))
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
