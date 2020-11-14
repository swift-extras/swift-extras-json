@testable import ExtrasJSON
import XCTest

class NumberParserTests: XCTestCase {
    func testNumberWithEverything() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("-12.12e+12".utf8)))
        XCTAssertEqual(result, .number("-12.12e+12"))
    }

    func testTwelve() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("12".utf8)))
        XCTAssertEqual(result, .number("12"))
    }

    func testMinusTwelve() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("-12".utf8)))
        XCTAssertEqual(result, .number("-12"))
    }

    func testMinusTwelvePointOne() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("-12.1".utf8)))
        XCTAssertEqual(result, .number("-12.1"))
    }

    func testMinusTwelvePoint() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("-12.".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }

    func testMinusTwelveExp1() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("-12e1".utf8)))
        XCTAssertEqual(result, .number("-12e1"))
    }

    func testMinusTwelveExpMinus1() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("-12e-1".utf8)))
        XCTAssertEqual(result, .number("-12e-1"))
    }

    func testMinusTwelveExpMinus() {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("-12e-".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }

    func testTwelvePointOneWithExp() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("12.1e-1".utf8)))
        XCTAssertEqual(result, .number("12.1e-1"))
    }

    func testHighExp() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("1000e1000".utf8)))
        XCTAssertEqual(result, .number("1000e1000"))
    }

    func testLeadingZero() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("01".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .numberWithLeadingZero(index: 1))
        }
    }

    func testLeadingZeroNegative() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("-01".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .numberWithLeadingZero(index: 2))
        }
    }

    func testZeroPointOne() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("0.1".utf8)))
        XCTAssertEqual(result, .number("0.1"))
    }

    func testZeroPointZeroOne() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("0.01".utf8)))
        XCTAssertEqual(result, .number("0.01"))
    }

    func testZeroPointZeroZeroOne() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("0.001".utf8)))
        XCTAssertEqual(result, .number("0.001"))
    }

    func testOnePointZeroZeroZeroAllowed() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("1.000".utf8)))
        XCTAssertEqual(result, .number("1.000"))
    }

    func testZeroExpOne() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("0e1".utf8)))
        XCTAssertEqual(result, .number("0e1"))
    }

    func testZeroExpZero() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("0e0".utf8)))
        XCTAssertEqual(result, .number("0e0"))
    }

    func testZeroExpMinusZero() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("0e-0".utf8)))
        XCTAssertEqual(result, .number("0e-0"))
    }

    func testMinusPoint() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("-.".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "."), characterIndex: 1))
        }
    }

    func testSpaceInBetween() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("1 000".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "0"), characterIndex: 2))
        }
    }

    func testExpWithCapitalLetter() throws {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("5E7".utf8)))
        XCTAssertEqual(result, .number("5E7"))
    }
}
