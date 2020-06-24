@testable import PureSwiftJSONParsing
import XCTest

class NullParserTests: XCTestCase {
    func testSimpleNull() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8]("null".utf8)))
        XCTAssertEqual(result, .null)
    }

    func testMiddleCharacterInvalidCase() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("nuLl".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedCharacter(ascii: UInt8(ascii: "L"), characterIndex: 2))
        }
    }

    func testNullMissingEnd() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("nul".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }
}
