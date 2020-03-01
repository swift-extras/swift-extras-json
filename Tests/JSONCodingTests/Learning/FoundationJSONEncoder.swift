import XCTest
import PureSwiftJSONParsing

class FoundationJSONEncoderTests: XCTestCase {
  
  struct HelloWorld: Encodable {
    struct SubType {
      let value: UInt
    }
    
    let hello = "Hello \tWorld"
    let subs : [SubType] = [SubType(value: 1), SubType(value: 1), SubType(value: 1)]
  }
  
  func testEncodeHelloWorld() throws {
    let hello = HelloWorld()
    let result = try JSONEncoder().encode(hello)
    
    let value = try JSONParser().parse(bytes: result)
    XCTAssertEqual(value, .object([
      "hello": .string("Hello \tWorld"),
      "subs": .array([.number("1"), .number("1"), .number("1")])
    ]))
  }
  
  #if canImport(Darwin)
  // this works only on Darwin, on Linux an error is thrown.
  func testEncodeNull() throws {
    do {
      let result = try JSONEncoder().encode(nil as String?)
      
      let json = String(data: result, encoding: .utf8)
      XCTAssertEqual(json, "null")
    }
  }
  #endif
}

extension FoundationJSONEncoderTests.HelloWorld.SubType: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case value
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}
