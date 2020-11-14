@testable import ExtrasJSON
import XCTest

class ArrayParserTests: XCTestCase {
    func testEmptyArray() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("[]".utf8)))
        XCTAssertEqual(result, .array([]))
    }

    func testSimpleTrueArray() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("[   true   ]".utf8)))
        XCTAssertEqual(result, .array([.bool(true)]))
    }

    func testNestedArrays() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("[[]]".utf8)))
        XCTAssertEqual(result, .array([.array([])]))
    }

    func testHighlyNestedArray() {
        // test 512 should succeed
        let passingString = String(repeating: "[", count: 512) + String(repeating: "]", count: 512)
        XCTAssertNoThrow(_ = try JSONParser().parse(bytes: [UInt8](passingString.utf8)))

        let failingString = String(repeating: "[", count: 513)
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](failingString.utf8))) { error in
            XCTAssertEqual(error as? JSONError, .tooManyNestedArraysOrDictionaries(characterIndex: 512))
        }
    }

    func testSimpleTrueAndStringArray() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#"[   true  , "hello" ]"#.utf8)))
        XCTAssertEqual(result, .array([.bool(true), .string("hello")]))
    }

    func testCommaBeforeEnd() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("[   true  , ]".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "]"), characterIndex: 12))
        }
    }

    func testInvalidCharacterAfterFirstValue() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("[ true asd ]".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "a"), characterIndex: 7))
        }
    }

    func testNumberCommaBeforeEnd() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("[   1  , ]".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "]"), characterIndex: 9))
        }
    }

    func testIncompleteLiteralInArray() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("[ nu ]".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: " "), characterIndex: 4))
        }
    }
}
