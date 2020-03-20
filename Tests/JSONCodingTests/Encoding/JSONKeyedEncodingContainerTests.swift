import XCTest
@testable import PureSwiftJSONCoding
@testable import PureSwiftJSONParsing

class JSONKeyedEncodingContainerTests: XCTestCase {
  
  func testNestedKeyedContainer() {
    struct Object: Encodable {
      let firstName: String
      let surname: String

      func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nameContainer = container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        try nameContainer.encode(firstName, forKey: .firstName)
        
        var sameContainer = container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        try sameContainer.encode(surname, forKey: .surname)
      }

      private enum CodingKeys: String, CodingKey {
        case name = "name"
      }

      private enum NameCodingKeys: String, CodingKey {
        case firstName = "firstName"
        case surname = "surname"
      }
    }
    
    do {
      let object = Object(firstName: "Adam", surname: "Fowler")
      let json = try PureSwiftJSONCoding.JSONEncoder().encode(object)
      
      let parsed = try JSONParser().parse(bytes: json)
      XCTAssertEqual(parsed, .object(["name": .object(["firstName": .string("Adam"), "surname": .string("Fowler")])])) 
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testNestedUnkeyedContainer() {
    struct NumberStruct: Encodable {
      func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var numbersContainer = container.nestedUnkeyedContainer(forKey: .numbers)
        var sameContainer = container.nestedUnkeyedContainer(forKey: .numbers)
        
        try numbersContainer.encode(1)
        try sameContainer.encode(2)
        try numbersContainer.encode(3)
        try sameContainer.encode(4)
      }

      private enum CodingKeys: String, CodingKey {
        case numbers
      }
    }
    
    do {
      let object = NumberStruct()
      let json = try PureSwiftJSONCoding.JSONEncoder().encode(object)
      
      let parsed = try JSONParser().parse(bytes: json)
      XCTAssertEqual(parsed, .object(["numbers": .array([.number("1"), .number("2"), .number("3"), .number("4")])]))
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
}



