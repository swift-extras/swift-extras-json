import XCTest
@testable import PureSwiftJSONCoding
@testable import PureSwiftJSONParsing

class JSONKeyedEncodingContainerTests: XCTestCase {
  
  // MARK: - NaN & Inf -
  
  struct DoubleBox: Encodable {
    let number: Double
  }
  
  func testEncodeDoubleNAN() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(DoubleBox(number: .nan))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Double, let context) {
      XCTAssert(value.isNaN) // expected
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath.first?.stringValue, "number")
      XCTAssertEqual(context.debugDescription, "Unable to encode Double.nan directly in JSON.")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeDoubleInf() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(DoubleBox(number: .infinity))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Double, let context) {
      XCTAssert(value.isInfinite) // expected
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath.first?.stringValue, "number")
      XCTAssertEqual(context.debugDescription, "Unable to encode Double.inf directly in JSON.")
    }
    catch {
      // missing expected catch
       XCTFail("Unexpected error: \(error)")
    }
  }
  
  struct FloatBox: Encodable {
    let number: Float
  }
  
  func testEncodeFloatNAN() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(FloatBox(number: .nan))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Float, let context) {
      XCTAssert(value.isNaN) // expected
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath.first?.stringValue, "number")
      XCTAssertEqual(context.debugDescription, "Unable to encode Float.nan directly in JSON.")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncodeFloatInf() {
    do {
      let result = try PureSwiftJSONCoding.JSONEncoder().encode(FloatBox(number: .infinity))
      XCTFail("Did not expect to have a result: \(result)")
    }
    catch Swift.EncodingError.invalidValue(let value as Float, let context) {
      XCTAssert(value.isInfinite) // expected
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath.first?.stringValue, "number")
      XCTAssertEqual(context.debugDescription, "Unable to encode Float.inf directly in JSON.")
    }
    catch {
      // missing expected catch
       XCTFail("Unexpected error: \(error)")
    }
  }

  
  // MARK: - Nested Container -
  
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



