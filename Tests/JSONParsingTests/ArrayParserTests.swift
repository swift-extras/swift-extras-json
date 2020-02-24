import XCTest
@testable import PureSwiftJSONParsing

class ArrayParserTests: XCTestCase {
  
  func testEmptyArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("[]".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseArray()
    XCTAssertEqual(result, [])
  }
  
  func testSimpleTrueArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("[   true   ]".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseArray()
    XCTAssertEqual(result, [.bool(true)])
  }
  
  func testSimpleTrueAndStringArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8](#"[   true  , "hello" ]"#.utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseArray()
    XCTAssertEqual(result, [.bool(true), .string("hello")])
  }
  
  func testCommaBeforeEnd() throws {
    do {
      var parser = JSONParserImpl(bytes: [UInt8]("[   true  , ]".utf8))
      _ = try XCTUnwrap(parser.reader.read())
      _ = try parser.parseArray()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "]")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testInvalidCharacterAfterFirstValue() throws {
    do {
      var parser = JSONParserImpl(bytes: [UInt8]("[ true asd ]".utf8))
      _ = try XCTUnwrap(parser.reader.read())
      _ = try parser.parseArray()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "a")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
