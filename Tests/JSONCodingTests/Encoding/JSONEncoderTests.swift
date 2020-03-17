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
  
  func testEncodeDoubleNAN() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(Double.nan)
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Double, let context) {
      XCTAssert(value.isNaN) // expected
      XCTAssertEqual(context.codingPath.count, 0)
      XCTAssertEqual(context.debugDescription, "Unable to encode Double.nan directly in JSON.")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeDoubleInf() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(Double.infinity)
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Double, let context) {
      XCTAssert(value.isInfinite) // expected
      XCTAssertEqual(context.codingPath.count, 0)
      XCTAssertEqual(context.debugDescription, "Unable to encode Double.inf directly in JSON.")
    }
    catch {
      // missing expected catch
       XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeFloatNAN() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(Float.nan)
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Float, let context) {
      XCTAssert(value.isNaN) // expected
      XCTAssertEqual(context.codingPath.count, 0)
      XCTAssertEqual(context.debugDescription, "Unable to encode Float.nan directly in JSON.")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeFloatInf() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(Float.infinity)
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Float, let context) {
      XCTAssert(value.isInfinite) // expected
      XCTAssertEqual(context.codingPath.count, 0)
      XCTAssertEqual(context.debugDescription, "Unable to encode Float.inf directly in JSON.")
    }
    catch {
      // missing expected catch
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

