import XCTest
@testable import PureSwiftJSONCoding
@testable import PureSwiftJSONParsing

class JSONEncoderTests: XCTestCase {
  
  struct HelloWorld: Encodable {
    let hello: String
    let test: Bool = false
    let numbers: [UInt] = [12, 123, 23435]
    let number: UInt = 12
  }
  
  func testEncodeHelloWorld() {
    do {
      let hello = HelloWorld(hello: "world")
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(hello)
      let parsed = try JSONParser().parse(bytes: result)
      
      XCTAssertEqual(parsed, .object([
        "hello": .string("world"),
        "test": .bool(false),
        "number": .number("12"),
        "numbers": .array([.number("12"), .number("123"), .number("23435")])
      ]))
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeTopLevel12() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(12)
      
      XCTAssertEqual(String(bytes: result, encoding: .utf8), "12")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeTopLevelTrue() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(true)
      
      XCTAssertEqual(String(bytes: result, encoding: .utf8), "true")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeTopLevelNull() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(nil as String?)
      
      XCTAssertEqual(String(bytes: result, encoding: .utf8), "null")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeTopLevelString() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode("Hello World")
      
      XCTAssertEqual(String(bytes: result, encoding: .utf8), #""Hello World""#)
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeQuote() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode("\"")
      let json = String(bytes: result, encoding: String.Encoding.utf8)
      XCTAssertEqual(json, "\"\\\"\"")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testLastCodingPath() {
    struct SubObject: Encodable {
      let value: Int

      func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let key = encoder.codingPath.last {
          try container.encode(key.stringValue, forKey: .key)
          try container.encode(value, forKey: .value)
        }
      }

      private enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
      }
    }

    struct Object: Encodable {
      let sub: SubObject
    }

    do {
      let object = Object(sub: SubObject(value: 12))
      let json = try PureSwiftJSONCoding.JSONEncoder().encode(object)
      let parsed = try JSONParser().parse(bytes: json)
      XCTAssertEqual(parsed, .object(["sub": .object(["key": .string("sub"), "value": .number("12")])]))
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}

