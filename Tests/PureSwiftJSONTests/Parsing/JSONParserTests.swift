@testable import PureSwiftJSON
import XCTest

class JSONParserTests: XCTestCase {
    func testTopLevelBoolTrue() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("true".utf8)))
        XCTAssertEqual(result, .bool(true))
    }

    func testTopLevelBoolTrueWhitespaceAround() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("\t   true \n\t".utf8)))
        XCTAssertEqual(result, .bool(true))
    }

    func testTopLevelBoolFalse() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("false".utf8)))
        XCTAssertEqual(result, .bool(false))
    }

    func testEmptyString() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }

    func testValueAfterTopLevelElementString() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("true  x".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "x"), characterIndex: 6))
        }
    }

    func testValueAfterTopLevelElementNumber() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("12.678}".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "}"), characterIndex: 6))
        }
    }

    func testMoreComplexObject() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#"{"hello":[12,12,true,null,["abc"]]}"# .utf8)))
        XCTAssertEqual(result, .object(["hello": .array([.number("12"), .number("12"), .bool(true), .null, .array([.string("abc")])])]))
    }

    func testHighlyNestedObjectAndDictionary() {
        // test 512 should succeed
        let passingString = String(repeating: #"{"a":["#, count: 256) + "null" + String(repeating: "]}", count: 256)
        XCTAssertNoThrow(_ = try JSONParser().parse(bytes: [UInt8](passingString.utf8)))

        let failingString = String(repeating: #"{"a":["#, count: 257)
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](failingString.utf8))) { error in
            XCTAssertEqual(error as? JSONError, .tooManyNestedArraysOrDictionaries(characterIndex: 1536))
        }
    }
}
