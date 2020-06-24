@testable import PureSwiftJSONParsing
import XCTest

class BoolParserTests: XCTestCase {
    func testSimpleTrue() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("true".utf8)))
        XCTAssertEqual(result, .bool(true))
    }

    func testSimpleFalse() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("false".utf8)))
        XCTAssertEqual(result, .bool(false))
    }

    func testTrueMissingEnd() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("tr".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }

    func testFalseMissingEnd() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("fal".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }

    func testTrueMiddleCharacterInvalidCase() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("trUe".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "U"), characterIndex: 2))
        }
    }

    func testFalseMiddleCharacterInvalidCase() {
        // rfc8259 §3
        // The literal names MUST be lowercase.  No other literal names are allowed.
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("faLse".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "L"), characterIndex: 2))
        }
    }

    func testInvalidCharacter() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("fal67".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "6"), characterIndex: 3))
        }
    }
}
