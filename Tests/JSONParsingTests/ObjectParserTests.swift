import XCTest
@testable import PureSwiftJSONParsing

class ObjectParserTests: XCTestCase {
  
  func testEmptyArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("{}".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, [:])
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
    // rfc does not directly define how to handle duplicate key
    // parser should be able to parse anyways
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, ["a": .string("bar")])
  }

  
  func testSimpleKeyValueArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("{ \"hello\" : \"world\" }".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, ["hello": .string("world")])
  }
  
  func testTwoKeyValueArray() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("{ \"hello\" : \"world\", \"haha\" \n\t: true }".utf8))
    let _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseObject()
    XCTAssertEqual(result, ["hello": .string("world"), "haha": .bool(true)])
  }

  

}
