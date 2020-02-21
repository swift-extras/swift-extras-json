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
  
  func testEncodeTopLevelString() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode("Hello World")
      
      XCTAssertEqual(String(bytes: result, encoding: .utf8), "\"Hello World\"")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeDoubleNAN() {
    
     do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(Double.nan)
      XCTFail("this point should not be reached")
       
     }
     catch {
      // missing expected catch
       XCTFail("Unexpected error: \(error)")
     }
   }
  
  func testEncodeDoubleInf() {
    
     do {
      let _ = try PureSwiftJSONCoding.JSONEncoder().encode(Double.infinity)
      XCTFail("this point should not be reached")
       
     }
     catch {
      // missing expected catch
       XCTFail("Unexpected error: \(error)")
     }
   }
  
  func testEncodeQuote() {
    do {
     let result = try PureSwiftJSONCoding.JSONEncoder().encode("\"")
     
     XCTAssertEqual(result, "\\\"")
    }
    catch {
       XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeQuote() {
    do {
     let result = try PureSwiftJSONCoding.JSONEncoder().encode("\"")
     
     XCTAssertEqual(result, "\\\"")
    }
    catch {
       XCTFail("Unexpected error: \(error)")
    }
  }
}

