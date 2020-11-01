@testable import PureSwiftJSON
import XCTest

class JSONValueTests: XCTestCase {
    // MARK: - String tests -

    func testEncodeControlCharacters() {
        // All Unicode characters may be placed within the
        // quotation marks, except for the characters that MUST be escaped:
        // quotation mark, reverse solidus, and the control characters (U+0000
        // through U+001F).
        // https://tools.ietf.org/html/rfc8259#section-7

        let expected = [
            #""\u0000""#,
            #""\u0001""#,
            #""\u0002""#,
            #""\u0003""#,
            #""\u0004""#,
            #""\u0005""#,
            #""\u0006""#,
            #""\u0007""#,
            #""\b""#,
            #""\t""#,
            #""\n""#,
            #""\u000B""#,
            #""\f""#,
            #""\r""#,
            #""\u000E""#,
            #""\u000F""#,
            #""\u0010""#,
            #""\u0011""#,
            #""\u0012""#,
            #""\u0013""#,
            #""\u0014""#,
            #""\u0015""#,
            #""\u0016""#,
            #""\u0017""#,
            #""\u0018""#,
            #""\u0019""#,
            #""\u001A""#,
            #""\u001B""#,
            #""\u001C""#,
            #""\u001D""#,
            #""\u001E""#,
            #""\u001F""#,
        ]
        
        for index in 0 ... 31 {
            let controlCharacters = Unicode.Scalar(index)!
            let value = JSONValue.string("\(controlCharacters)")

            var bytes = [UInt8]()
            value.appendBytes(to: &bytes)

            XCTAssertEqual(String(decoding: bytes, as: Unicode.UTF8.self), expected[index])
        }
    }

    func testEncodeQuotationMark() {
        let value = JSONValue.string("\"")
        var bytes = [UInt8]()
        value.appendBytes(to: &bytes)

        let expected: [UInt8] = [
            UInt8(ascii: "\""),
            92, // backslash to escape
            UInt8(ascii: "\""), // actual quotation mark
            UInt8(ascii: "\""),
        ]

        XCTAssertEqual(bytes, expected)
    }

    func testEncodeReverseSolidus() {
        let value = JSONValue.string("\\")
        var bytes = [UInt8]()
        value.appendBytes(to: &bytes)

        let expected: [UInt8] = [
            UInt8(ascii: "\""),
            92, // backslash to escape
            UInt8(ascii: "\\"), // actual reverse solidus
            UInt8(ascii: "\""),
        ]

        XCTAssertEqual(bytes, expected)
    }

    func testEmojiAvocado() {
        let value = JSONValue.string("🥑")
        var bytes = [UInt8]()
        value.appendBytes(to: &bytes)
        XCTAssertEqual(bytes, [UInt8](#""🥑""# .utf8))
    }

    func testEmojiFamily() {
        let value = JSONValue.string("👩‍👩‍👧‍👧")
        var bytes = [UInt8]()
        value.appendBytes(to: &bytes)
        XCTAssertEqual(bytes, [UInt8](#""👩‍👩‍👧‍👧""# .utf8))
    }
}
