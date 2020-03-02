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
  
  func testNestedArrays() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("[[]]".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
   
    let result = try parser.parseArray()
    XCTAssertEqual(result, [.array([])])
  }
  
  func testHighlyNestedArray() throws {
    // test 512 should succeed
    let passingString = String(repeating: "[", count: 512) +  String(repeating: "]", count: 512)
    _  = try JSONParser().parse(bytes: [UInt8](passingString.utf8))
    
    let failingString = String(repeating: "[", count: 513)
    do {
      _  = try JSONParser().parse(bytes: [UInt8](failingString.utf8))
    }
    catch JSONError.tooManyNestedArraysOrDictionaries(characterIndex: 512) {
      //expected case
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testSimpleTrueAndStringArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8](#"[   true  , "hello" ]"#.utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseArray()
    XCTAssertEqual(result, [.bool(true), .string("hello")])
  }
  
  func testCommaBeforeEnd() {
    do {
      var parser = JSONParserImpl(bytes: [UInt8]("[   true  , ]".utf8))
      _ = try XCTUnwrap(parser.reader.read())
      _ = try parser.parseArray()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "]"), characterIndex: 12) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testInvalidCharacterAfterFirstValue() {
    do {
      var parser = JSONParserImpl(bytes: [UInt8]("[ true asd ]".utf8))
      _ = try XCTUnwrap(parser.reader.read())
      _ = try parser.parseArray()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "a"), characterIndex: 7) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testNumberCommaBeforeEnd() {
    do {
      var parser = JSONParserImpl(bytes: [UInt8]("[   1  , ]".utf8))
      _ = try XCTUnwrap(parser.reader.read())
      _ = try parser.parseArray()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "]"), characterIndex: 9) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testIncompleteLiteralInArray() throws {
    do {
      _ = try JSONParser().parse(bytes: [UInt8]("[ nu ]".utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: " "), characterIndex: 4) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
