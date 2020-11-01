@testable import PureSwiftJSON
import XCTest

class ObjectParserTests: XCTestCase {
    func testEmptyObject() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("{}".utf8)))
        XCTAssertEqual(result, .object([:]))
    }

    func testSimpleKeyValueArray() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#"{ "hello" : "world" }"#.utf8)))
        XCTAssertEqual(result, .object(["hello": .string("world")]))
    }

    func testTwoKeyValueArray() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes:
            [UInt8](#"{ "hello" : "world", "haha" \#n\#t: true }"#.utf8)))
        XCTAssertEqual(result, .object(["hello": .string("world"), "haha": .bool(true)]))
    }

    func testHighlyNestedObject() {
        // test 512 should succeed
        let passingString = String(repeating: #"{"a":"#, count: 512) + "null" + String(repeating: "}", count: 512)
        XCTAssertNoThrow(_ = try JSONParser().parse(bytes: [UInt8](passingString.utf8)))

        let failingString = String(repeating: #"{"a":"#, count: 513)
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](failingString.utf8))) { error in
            XCTAssertEqual(error as? JSONError, .tooManyNestedArraysOrDictionaries(characterIndex: 2560))
        }
    }

    func testEmptyKey() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("{\"\": \"foobar\"}".utf8)))
        XCTAssertEqual(result, .object(["": .string("foobar")]))
    }

    func testDuplicateKey() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("{\"a\": \"foo\", \"a\": \"bar\"}".utf8)))

        // current behavior is last key is given, should be documented?
        // rfc does not define how to handle duplicate keys
        // parser should be able to parse anyways

        XCTAssertEqual(result, .object(["a": .string("bar")]))
    }
}
