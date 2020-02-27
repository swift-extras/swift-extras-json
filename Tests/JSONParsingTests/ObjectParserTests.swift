import XCTest
@testable import PureSwiftJSONParsing

class ObjectParserTests: XCTestCase {
  
  func testEmptyArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("{}".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, [:])
  }
  
  func testSimpleKeyValueArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8](#"{ "hello" : "world" }"#.utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, ["hello": .string("world")])
  }
  
  func testTwoKeyValueArray() throws {
    let jsonString = #"{ "hello" : "world", "haha" \#n\#t: true }"#
    var parser = JSONParserImpl(bytes: [UInt8](jsonString.utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, ["hello": .string("world"), "haha": .bool(true)])
  }
  
  func testHighlyNestedObject() throws {
    // test 512 should succeed
    let passingString = String(repeating: #"{"a":"#, count: 512) + "null" + String(repeating: "}", count: 512)
    _  = try JSONParser().parse(bytes: [UInt8](passingString.utf8))
    
    let failingString = String(repeating: #"{"a":"#, count: 513)
    do {
      _  = try JSONParser().parse(bytes: [UInt8](failingString.utf8))
    }
    catch JSONError.tooManyNestedArraysOrDictionaries(characterIndex: 2560) {
      //expected case
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEmptyKey() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("{\"\": \"foobar\"}".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, ["": .string("foobar")])
  }
  
  func testDuplicateKey() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("{\"a\": \"foo\", \"a\": \"bar\"}".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    // current behavior is last key is given, should be documented?
    // rfc does not define how to handle duplicate keys
    // parser should be able to parse anyways
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, ["a": .string("bar")])
  }

}
