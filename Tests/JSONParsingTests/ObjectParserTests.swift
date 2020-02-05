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
