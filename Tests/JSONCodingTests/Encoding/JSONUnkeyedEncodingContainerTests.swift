import XCTest
@testable import PureSwiftJSONCoding
@testable import PureSwiftJSONParsing

class JSONUnkeyedEncodingContainerTests: XCTestCase {
  
  func testNestedKeyedContainer() {
    struct ObjectInArray: Encodable {
      let firstName: String
      let surname: String

      func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        var nestedContainer = container.nestedContainer(keyedBy: NameCodingKeys.self)
        try nestedContainer.encode(firstName, forKey: .firstName)
        try nestedContainer.encode(surname, forKey: .surname)
      }
      
      private enum NameCodingKeys: String, CodingKey {
        case firstName = "firstName"
        case surname = "surname"
      }
    }
    
    do {
      let object = ObjectInArray(firstName: "Adam", surname: "Fowler")
      let json = try PureSwiftJSONCoding.JSONEncoder().encode(object)
      
      let parsed = try JSONParser().parse(bytes: json)
      XCTAssertEqual(parsed, .array([.object(["firstName": .string("Adam"), "surname": .string("Fowler")])]))
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testNestedUnkeyedContainer() {
    struct NumbersInArray: Encodable {
      let numbers: [Int]
      
      func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        var numbersContainer = container.nestedUnkeyedContainer()
        try numbers.forEach() { try numbersContainer.encode($0) }
      }

      private enum CodingKeys: String, CodingKey {
        case numbers
      }
    }

    do {
      let object = NumbersInArray(numbers: [1, 2, 3, 4])
      let json = try PureSwiftJSONCoding.JSONEncoder().encode(object)

      let parsed = try JSONParser().parse(bytes: json)
      XCTAssertEqual(parsed, .array([.array([.number("1"), .number("2"), .number("3"), .number("4")])]))
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}



