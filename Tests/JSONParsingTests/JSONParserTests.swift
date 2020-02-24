import XCTest
@testable import PureSwiftJSONParsing

class JSONParserTests: XCTestCase {
  
  func testTopLevelBoolTrue() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("true".utf8))
    XCTAssertEqual(result, .bool(true))
  }
  
  func testTopLevelBoolTrueWhitespaceAround() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("\t   true \n\t".utf8))
    XCTAssertEqual(result, .bool(true))
  }
  
  func testTopLevelBoolFalse() throws {
    let result = try JSONParser().parse(bytes: [UInt8]("false".utf8))
    XCTAssertEqual(result, .bool(false))
  }
  
  func testEmptyString() {
    do {
      _ = try JSONParser().parse(bytes: [UInt8]("".utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testValueAfterTopLevelElementString() {
    do {
      _ = try JSONParser().parse(bytes: [UInt8]("true  x".utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "x")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testValueAfterTopLevelElementNumber() {
    do {
      _ = try JSONParser().parse(bytes: [UInt8]("12.678}".utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "}")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testMoreComplexObject() throws {
    do {
      let result = try JSONParser().parse(bytes: [UInt8](#"{"hello":[12,12,true,null,["abc"]]}"#.utf8))
      XCTAssertEqual(result, .object(["hello": .array([.number("12"), .number("12"), .bool(true), .null, .array([.string("abc")])])]))
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testHighlyNestedObjectAndDictionary() throws {
    // test 512 should succeed
    let passingString = String(repeating: #"{"a":["#, count: 256) + "null" + String(repeating: "]}", count: 256)
    _  = try JSONParser().parse(bytes: [UInt8](passingString.utf8))
    
    let failingString = String(repeating: #"{"a":["#, count: 257)
    do {
      _  = try JSONParser().parse(bytes: [UInt8](failingString.utf8))
    }
    catch JSONError.tooManyNestedArraysOrDictionaries(characterIndex: 1536) {
      //expected case
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

}
