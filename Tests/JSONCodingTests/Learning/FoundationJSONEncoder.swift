import XCTest

class FoundationJSONEncoderTests: XCTestCase {
  
  struct HelloWorld: Encodable {
    struct SubType {
      let value: UInt
    }
    
    let subs: [SubType] = [SubType(value: 1), SubType(value: 1), SubType(value: 1)]
  }
  
  func testEncodeHelloWorld() throws {
    do {
      let hello = HelloWorld()
      let result = try JSONEncoder().encode(hello)
      
      print(result)
    }
  }
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
