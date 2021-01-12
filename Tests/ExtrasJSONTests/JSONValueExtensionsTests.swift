import ExtrasJSON
import XCTest

class JSONValueDecodingTests: XCTestCase {
    let encoder = XJSONEncoder()
    let decoder = XJSONDecoder()

    func testInteger() throws {
        let intJSON: JSONValue = 12
        let encoded = try encoder.encode(intJSON)
        XCTAssertEqual(Int(String(bytes: encoded, encoding: .utf8)!), intJSON.intValue)

        let decoded = try decoder.decode(JSONValue.self, from: encoded)
        XCTAssertEqual(decoded.intValue, intJSON.intValue)
    }

    func testDouble() throws {
        let doubleJSON: JSONValue = 12.3
        let encoded = try encoder.encode(doubleJSON)
        XCTAssertEqual(Double(String(bytes: encoded, encoding: .utf8)!)!, doubleJSON.doubleValue!, accuracy: 0.0001)

        let decoded = try decoder.decode(JSONValue.self, from: encoded)
        XCTAssertEqual(decoded.doubleValue!, doubleJSON.doubleValue!, accuracy: 0.0001)
    }

    func testString() throws {
        let stringJSON: JSONValue = "I am a String"
        let encoded = try encoder.encode(stringJSON)
        XCTAssertEqual(String(bytes: encoded, encoding: .utf8), "\"I am a String\"")
        let decoded = try decoder.decode(JSONValue.self, from: encoded)
        XCTAssertEqual(decoded, stringJSON)
    }

    func testBool() throws {
        let boolJSON: JSONValue = true
        let encoded = try encoder.encode(boolJSON)
        XCTAssertEqual(String(bytes: encoded, encoding: .utf8), "true")
        let decoded = try decoder.decode(JSONValue.self, from: encoded)
        XCTAssertEqual(decoded, boolJSON)
    }

    func testArray() throws {
        let arrayJSON: JSONValue = ["I am a string in an array"]
        let encoded = try encoder.encode(arrayJSON)
        let decoded = try decoder.decode(JSONValue.self, from: encoded)
        XCTAssertEqual(String(bytes: encoded, encoding: .utf8), "[\"I am a string in an array\"]")
        XCTAssertEqual(decoded, arrayJSON)
    }

    func testObject() throws {
        let objectJSON: JSONValue = ["Key": "Value"]
        let encoded = try encoder.encode(objectJSON)
        let decoded = try decoder.decode(JSONValue.self, from: encoded)
        XCTAssertEqual(String(bytes: encoded, encoding: .utf8), "{\"Key\":\"Value\"}")
        XCTAssertEqual(objectJSON.objectValue!["Key"]!.stringValue!, "Value")
        XCTAssertEqual(decoded, objectJSON)
    }
}
