@testable import PureSwiftJSON
import XCTest

class JSONEncoderTests: XCTestCase {
    struct HelloWorld: Encodable {
        let hello: String
        let test: Bool = false
        let numbers: [UInt] = [12, 123, 23435]
        let number: UInt = 12
    }

    func testEncodeHelloWorld() {
        let hello = HelloWorld(hello: "world")
        var result: [UInt8]?
        XCTAssertNoThrow(result = try PureSwiftJSON.JSONEncoder().encode(hello))
        var parsed: JSONValue?
        XCTAssertNoThrow(parsed = try JSONParser().parse(bytes: XCTUnwrap(result)))

        XCTAssertEqual(parsed, .object([
            "hello": .string("world"),
            "test": .bool(false),
            "number": .number("12"),
            "numbers": .array([.number("12"), .number("123"), .number("23435")]),
        ]))
    }

    func testEncodeTopLevel12() {
        var result: [UInt8]?
        XCTAssertNoThrow(result = try PureSwiftJSON.JSONEncoder().encode(12))
        XCTAssertEqual(String(bytes: try XCTUnwrap(result), encoding: .utf8), "12")
    }

    func testEncodeTopLevelTrue() {
        var result: [UInt8]?
        XCTAssertNoThrow(result = try PureSwiftJSON.JSONEncoder().encode(true))
        XCTAssertEqual(String(bytes: try XCTUnwrap(result), encoding: .utf8), "true")
    }

    func testEncodeTopLevelNull() {
        var result: [UInt8]?
        XCTAssertNoThrow(result = try PureSwiftJSON.JSONEncoder().encode(nil as String?))
        XCTAssertEqual(String(bytes: try XCTUnwrap(result), encoding: .utf8), "null")
    }

    func testEncodeTopLevelString() {
        var result: [UInt8]?
        XCTAssertNoThrow(result = try PureSwiftJSON.JSONEncoder().encode("Hello World"))
        XCTAssertEqual(String(bytes: try XCTUnwrap(result), encoding: .utf8), #""Hello World""#)
    }

    func testEncodeDoubleNAN() {
        XCTAssertThrowsError(_ = try PureSwiftJSON.JSONEncoder().encode(Double.nan)) { error in
            guard case let Swift.EncodingError.invalidValue(value as Double, context) = error else {
                XCTFail("Unexpected error: \(error)"); return
            }

            XCTAssert(value.isNaN)
            XCTAssertEqual(context.codingPath.count, 0)
            XCTAssertEqual(context.debugDescription, "Unable to encode Double.nan directly in JSON.")
        }
    }

    func testEncodeDoubleInf() {
        XCTAssertThrowsError(_ = try PureSwiftJSON.JSONEncoder().encode(Double.infinity)) { error in
            guard case let Swift.EncodingError.invalidValue(value as Double, context) = error else {
                XCTFail("Unexpected error: \(error)"); return
            }

            XCTAssert(value.isInfinite)
            XCTAssertEqual(context.codingPath.count, 0)
            XCTAssertEqual(context.debugDescription, "Unable to encode Double.inf directly in JSON.")
        }
    }

    func testEncodeFloatNAN() {
        XCTAssertThrowsError(_ = try PureSwiftJSON.JSONEncoder().encode(Float.nan)) { error in
            guard case let Swift.EncodingError.invalidValue(value as Float, context) = error else {
                XCTFail("Unexpected error: \(error)"); return
            }

            XCTAssert(value.isNaN)
            XCTAssertEqual(context.codingPath.count, 0)
            XCTAssertEqual(context.debugDescription, "Unable to encode Float.nan directly in JSON.")
        }
    }

    func testEncodeFloatInf() {
        XCTAssertThrowsError(_ = try PureSwiftJSON.JSONEncoder().encode(Float.infinity)) { error in
            guard case let Swift.EncodingError.invalidValue(value as Float, context) = error else {
                XCTFail("Unexpected error: \(error)"); return
            }

            XCTAssert(value.isInfinite)
            XCTAssertEqual(context.codingPath.count, 0)
            XCTAssertEqual(context.debugDescription, "Unable to encode Float.inf directly in JSON.")
        }
    }

    func testEncodeQuote() {
        var result: [UInt8]?
        XCTAssertNoThrow(result = try PureSwiftJSON.JSONEncoder().encode("\""))
        XCTAssertEqual(String(bytes: try XCTUnwrap(result), encoding: String.Encoding.utf8), "\"\\\"\"")
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
                case key
                case value
            }
        }

        struct Object: Encodable {
            let sub: SubObject
        }

        let object = Object(sub: SubObject(value: 12))

        var result: [UInt8]?
        XCTAssertNoThrow(result = try PureSwiftJSON.JSONEncoder().encode(object))
        var parsed: JSONValue?
        XCTAssertNoThrow(parsed = try JSONParser().parse(bytes: XCTUnwrap(result)))
        XCTAssertEqual(parsed, .object(["sub": .object(["key": .string("sub"), "value": .number("12")])]))
    }
}
