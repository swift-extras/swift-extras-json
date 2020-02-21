import XCTest
@testable import PureSwiftJSONCoding

class JSONDecoderTests: XCTestCase {
  
  struct HelloWorld: Codable {
    
    let hello: String
    let subStruct: SubStruct
    let test: Bool
    let number: UInt
    let numbers: [UInt]
    
    struct SubStruct: Codable, Equatable {
      let name: String
    }
  }
  
  func testDecodeHelloWorld() throws {
    do {
      let string = """
        {
          "hello":"world",
          "subStruct":{
            "name":"hihi"
          },
          "test":true,
          "number":123,
          "numbers":[
            12,
            345,
            78
          ]
        }
        """
      
      let result = try JSONDecoder().decode(HelloWorld.self, from: [UInt8](string.utf8))
      
      XCTAssertEqual(result.hello, "world")
      XCTAssertEqual(result.subStruct, HelloWorld.SubStruct(name: "hihi"))
      XCTAssertEqual(result.test, true)
      XCTAssertEqual(result.number, 123)
      XCTAssertEqual(result.numbers, [12, 345, 78])
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  

  func testDecodeOptional() throws {
    struct OptStruct: Codable {
       let nulled: String?
       let nonexistent: String?
     }
    
    do {
      let string = """
        {
          "nulled": null
        }
        """
      
      let result = try JSONDecoder().decode(OptStruct.self, from: [UInt8](string.utf8))
      
      XCTAssertEqual(result.nulled, nil)
      XCTAssertEqual(result.nonexistent, nil)
      
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}

